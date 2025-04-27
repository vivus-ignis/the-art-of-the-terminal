"""
The main method and signal handlers for agentredrabbit
"""
#!/usr/bin/env python
# -*- coding: utf-8 -*-

import logging
import os
import pickle
import signal
import sys
import threading

from __init__ import __version__

from config import ReadConfig
from utils import log_format
from transport import Transporter
from transport import setFailsafeQueue, getFailsafeQueue
from optparse import OptionParser

log = logging.getLogger(__name__)
threads = []
shutdown_event = None


def sighandler(signum, frame):
    """
    Signal handler method for agentredrabbit. Its purpose is to capture signals
    such as SIGTERM, SIGHUP, SIGQUIT, SIGINT and gracefully shutdown all the
    thread workers. signum and frame params are passed by `signal`
    """
    log.info("Starting graceful shutdown, caught signal #%s" % signum)
    global threads, shutdown_event
    shutdown_event.set()

    for thread in threads:
        thread.join()

    for thread in threads:
        log.info("%s running state = %s" % (thread, thread.is_alive()))


def main():
    """
    Main method for agentredrabbit. The workflow consists of parsing cmd arg,
    reading config file, have logger, signal handler setup, read from any
    previously dumped failsafe queue, configure thread event and lock objects,
    start threads and wait till a shutdown event is trigged upon which it dumps
    any leftover message from the in memory failsafe queue to a dump file.
    """
    log.setLevel(logging.INFO)
    parser = OptionParser(usage="%prog [-c config] [-v]",
                          version="%prog " + __version__)
    parser.add_option("-c", "--config",
                      dest="config_file", default=None,
                      help="config file")
    parser.add_option("-v", "--verbose",
                      action="store_true", dest="verbose", default=False,
                      help="increase debug level from INFO to DEBUG")
    (options, args) = parser.parse_args()

    # Read config file
    cfg_path = "/etc/agentredrabbit.conf"
    if options.config_file is not None:
        cfg_path = options.config_file
    config = ReadConfig(cfg_path)

    # Setup logger
    log_level = logging.INFO
    if options.verbose:
        log_level = logging.DEBUG

    logging.basicConfig(filename=config["log_file"], filemode="a",
                        level=log_level, format=log_format)
    logging.getLogger("pika").setLevel(logging.INFO)

    # Setup signal handlers
    signal.signal(signal.SIGTERM, sighandler)
    signal.signal(signal.SIGINT, sighandler)
    signal.signal(signal.SIGQUIT, sighandler)
    signal.signal(signal.SIGHUP, sighandler)

    queues = filter(lambda x: x.strip() != "", config["queues"].split(":"))

    # Failsafe queue handling
    failsafeq = {}
    # Read from dump file if available
    dumpfilename = config["dump_file"]
    if os.path.exists(dumpfilename):
        with open(dumpfilename, "rb") as dumpfile:
            failsafeq = pickle.load(dumpfile)
            log.info("Loaded failsafeq: " + str(failsafeq))
    for queue in queues:
        if not queue in failsafeq:
            failsafeq[queue] = []
    setFailsafeQueue(failsafeq)

    # Start threads
    global threads, shutdown_event
    shutdown_event = threading.Event()
    qlock = threading.Lock()
    threadcount = int(config["workers"])
    log.info("[+] Starting workers for queues: " + ", ".join(queues))
    for idx, queue in enumerate(queues * threadcount):
        thread = Transporter(idx, qlock, config, queue, shutdown_event)
        thread.start()
        threads.append(thread)

    # Hang on till a shutdown event is triggered
    while not shutdown_event.is_set():
        signal.pause()

    # Dump in failsafeq to the dump file
    try:
        log.info("Dumping failsafe queue")
        dumpfile = open(dumpfilename, "wb")
        pickle.dump(getFailsafeQueue(), dumpfile)
        dumpfile.close()
    except IOError, err:
        log.error("Dumpiing failsafe queue failed: %s", err)
    log.info("We had a clean shutdown, Bye!")
    sys.exit(0)


if __name__ == "__main__":
    main()
