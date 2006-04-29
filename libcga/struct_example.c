struct {
  int num_widgets;
  char widget_name[255];
} widget_s;
typedef struct widget_s widget_t;

widget_t* widget_new() { 
  return (widget_t*)malloc(sizeof(struct widget_s)); 
}
void widget_delete(widget_t *self) { 
  free(self); 
}
void widget_set_num(widget_t *self, int num) { 
  self->num_widgets = num; 
} 
