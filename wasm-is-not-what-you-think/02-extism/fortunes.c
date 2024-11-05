#define EXTISM_IMPLEMENTATION
#include "extism-pdk.h"
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

const char* fortunes[] = {
    "Be consistent. -- Larry Wall in the perl man page",
    "C is quirky, flawed, and an enormous success -- Dennis M. Ritchie",
    "The good thing about standards is that there are so many to choose from. -- Andrew S. Tanenbaum",
    "Software is like sex; it's better when it's free. -- Linus Torvalds",
    "Computers are useless. They can only give you answers. -- Pablo Picasso"
};

#define FORTUNES_COUNT (sizeof(fortunes) / sizeof(fortunes[0]))

int get_random_index() {
    srand((unsigned int)time(NULL));
    return rand() % FORTUNES_COUNT;
}

int32_t EXTISM_EXPORTED_FUNCTION(get_random_phrase) {
    int random_index = get_random_index();

    const uint64_t quote_len = strlen(fortunes[random_index]);
    ExtismHandle handle = extism_alloc(quote_len + 1);
    extism_store_to_handle(handle, 0, fortunes[random_index], quote_len + 1);
    extism_output_set_from_handle(handle, 0, quote_len);

    return 0;
}
