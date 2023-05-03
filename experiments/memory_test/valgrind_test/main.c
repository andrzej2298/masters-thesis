#include <bson/bson.h>
#include <stdio.h>

void *__jsonnet_internal_meta_add();
void *__jsonnet_export_add(const void *in);
void *__jsonnet_export_get_constant();
void *__jsonnet_internal_allocate(unsigned size);
void __jsonnet_internal_deallocate(void *pointer, unsigned capacity);

int main() {
  /////////////////////////////////
  // function that takes parameters
  /////////////////////////////////
  // check what parameters the function takes
  uint8_t *result_params = __jsonnet_internal_meta_add();
  int32_t result_params_size = *((int32_t *)result_params);
  bson_t *result_params_bson = bson_new_from_data(result_params, result_params_size);

  // print parameter names
  char *result_params_json = bson_as_canonical_extended_json(result_params_bson, NULL);
  printf("%s\n", result_params_json);

  // deallocate parameter names
  bson_free(result_params_json);
  bson_destroy(result_params_bson);
  __jsonnet_internal_deallocate(result_params, result_params_size);

  // prepare arguments #1
  bson_t *argument_bson;
  argument_bson = BCON_NEW("x", BCON_DOUBLE(1.), "y", BCON_DOUBLE(2.));
  uint8_t *data = __jsonnet_internal_allocate(argument_bson->len * (sizeof *data));
  memcpy(data, bson_get_data(argument_bson), argument_bson->len);

  // call function #1
  uint8_t *result = __jsonnet_export_add(data);
  int32_t result_size = *((int32_t *)result);
  bson_destroy(argument_bson);
  bson_t *result_bson = bson_new_from_data(result, result_size);

  // print result #1
  char *result_json = bson_as_canonical_extended_json(result_bson, NULL);
  printf("%s\n", result_json);

  // deallocate result #1
  bson_free(result_json);
  bson_destroy(result_bson);
  __jsonnet_internal_deallocate(result, result_size);

  /////////////////////////////////////////
  // function that does not take parameters
  // (different branch in the interpreter)
  /////////////////////////////////////////
  // prepare arguments
  uint8_t *result_2 = __jsonnet_export_get_constant();
  int32_t result_size_2 = *((int32_t *)result_2);
  bson_t *result_bson_2 = bson_new_from_data(result_2, result_size_2);

  // print result #2
  char *result_json_2 = bson_as_canonical_extended_json(result_bson_2, NULL);
  printf("%s\n", result_json_2);

  // deallocate result #2
  bson_free(result_json_2);
  bson_destroy(result_bson_2);
  __jsonnet_internal_deallocate(result_2, result_size_2);

  return 0;
}
