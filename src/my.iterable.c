/* my.iterable.c generated by valac 0.20.0, the Vala compiler
 * generated from my.iterable.vala, do not modify */


#include <glib.h>
#include <glib-object.h>
#include <gobject/gvaluecollector.h>


#define MY_TYPE_ITERABLE (my_iterable_get_type ())
#define MY_ITERABLE(obj) (G_TYPE_CHECK_INSTANCE_CAST ((obj), MY_TYPE_ITERABLE, MyIterable))
#define MY_IS_ITERABLE(obj) (G_TYPE_CHECK_INSTANCE_TYPE ((obj), MY_TYPE_ITERABLE))
#define MY_ITERABLE_GET_INTERFACE(obj) (G_TYPE_INSTANCE_GET_INTERFACE ((obj), MY_TYPE_ITERABLE, MyIterableIface))

typedef struct _MyIterable MyIterable;
typedef struct _MyIterableIface MyIterableIface;

#define MY_TYPE_ITERATOR (my_iterator_get_type ())
#define MY_ITERATOR(obj) (G_TYPE_CHECK_INSTANCE_CAST ((obj), MY_TYPE_ITERATOR, MyIterator))
#define MY_ITERATOR_CLASS(klass) (G_TYPE_CHECK_CLASS_CAST ((klass), MY_TYPE_ITERATOR, MyIteratorClass))
#define MY_IS_ITERATOR(obj) (G_TYPE_CHECK_INSTANCE_TYPE ((obj), MY_TYPE_ITERATOR))
#define MY_IS_ITERATOR_CLASS(klass) (G_TYPE_CHECK_CLASS_TYPE ((klass), MY_TYPE_ITERATOR))
#define MY_ITERATOR_GET_CLASS(obj) (G_TYPE_INSTANCE_GET_CLASS ((obj), MY_TYPE_ITERATOR, MyIteratorClass))

typedef struct _MyIterator MyIterator;
typedef struct _MyIteratorClass MyIteratorClass;
typedef struct _MyIteratorPrivate MyIteratorPrivate;

#define MY_TYPE_ILIST (my_ilist_get_type ())
#define MY_ILIST(obj) (G_TYPE_CHECK_INSTANCE_CAST ((obj), MY_TYPE_ILIST, MyIList))
#define MY_IS_ILIST(obj) (G_TYPE_CHECK_INSTANCE_TYPE ((obj), MY_TYPE_ILIST))
#define MY_ILIST_GET_INTERFACE(obj) (G_TYPE_INSTANCE_GET_INTERFACE ((obj), MY_TYPE_ILIST, MyIListIface))

typedef struct _MyIList MyIList;
typedef struct _MyIListIface MyIListIface;
#define _g_object_unref0(var) ((var == NULL) ? NULL : (var = (g_object_unref (var), NULL)))
typedef struct _MyParamSpecIterator MyParamSpecIterator;

struct _MyIterableIface {
	GTypeInterface parent_iface;
	MyIterator* (*iterator) (MyIterable* self);
};

struct _MyIterator {
	GTypeInstance parent_instance;
	volatile int ref_count;
	MyIteratorPrivate * priv;
};

struct _MyIteratorClass {
	GTypeClass parent_class;
	void (*finalize) (MyIterator *self);
};

struct _MyIListIface {
	GTypeInterface parent_iface;
	gpointer (*get) (MyIList* self, gint index);
	void (*set) (MyIList* self, gint index, gconstpointer val);
	void (*add) (MyIList* self, gconstpointer item);
	void (*add_range) (MyIList* self, gpointer* items, int items_length1);
	void (*add_collection) (MyIList* self, MyIList* coll);
	gboolean (*contains) (MyIList* self, gconstpointer item);
	void (*insert) (MyIList* self, gint position, gconstpointer item);
	void (*insert_all) (MyIList* self, gint position, gpointer* items, int items_length1);
	void (*insert_collection) (MyIList* self, gint position, MyIList* coll);
	void (*reverse) (MyIList* self);
	gint (*index_of) (MyIList* self, gconstpointer item);
	gint* (*index_of_all) (MyIList* self, gconstpointer item, int* result_length1);
	void (*remove) (MyIList* self, gconstpointer item);
	void (*remove_at) (MyIList* self, gint index);
	void (*remove_all) (MyIList* self, gconstpointer item);
	void (*remove_range) (MyIList* self, gint start, gint length);
	gint (*get_size) (MyIList* self);
};

struct _MyIteratorPrivate {
	GType g_type;
	GBoxedCopyFunc g_dup_func;
	GDestroyNotify g_destroy_func;
	MyIList* iter;
	gint index;
};

struct _MyParamSpecIterator {
	GParamSpec parent_instance;
};


static gpointer my_iterator_parent_class = NULL;

gpointer my_iterator_ref (gpointer instance);
void my_iterator_unref (gpointer instance);
GParamSpec* my_param_spec_iterator (const gchar* name, const gchar* nick, const gchar* blurb, GType object_type, GParamFlags flags);
void my_value_set_iterator (GValue* value, gpointer v_object);
void my_value_take_iterator (GValue* value, gpointer v_object);
gpointer my_value_get_iterator (const GValue* value);
GType my_iterator_get_type (void) G_GNUC_CONST;
GType my_iterable_get_type (void) G_GNUC_CONST;
MyIterator* my_iterable_iterator (MyIterable* self);
GType my_ilist_get_type (void) G_GNUC_CONST;
#define MY_ITERATOR_GET_PRIVATE(o) (G_TYPE_INSTANCE_GET_PRIVATE ((o), MY_TYPE_ITERATOR, MyIteratorPrivate))
enum  {
	MY_ITERATOR_DUMMY_PROPERTY
};
MyIterator* my_iterator_new (GType g_type, GBoxedCopyFunc g_dup_func, GDestroyNotify g_destroy_func, MyIList* i);
MyIterator* my_iterator_construct (GType object_type, GType g_type, GBoxedCopyFunc g_dup_func, GDestroyNotify g_destroy_func, MyIList* i);
gboolean my_iterator_next (MyIterator* self);
gint my_ilist_get_size (MyIList* self);
gboolean my_iterator_prev (MyIterator* self);
gpointer my_iterator_get (MyIterator* self);
gpointer my_ilist_get (MyIList* self, gint index);
static void my_iterator_finalize (MyIterator* obj);


MyIterator* my_iterable_iterator (MyIterable* self) {
	g_return_val_if_fail (self != NULL, NULL);
	return MY_ITERABLE_GET_INTERFACE (self)->iterator (self);
}


static void my_iterable_base_init (MyIterableIface * iface) {
	static gboolean initialized = FALSE;
	if (!initialized) {
		initialized = TRUE;
	}
}


GType my_iterable_get_type (void) {
	static volatile gsize my_iterable_type_id__volatile = 0;
	if (g_once_init_enter (&my_iterable_type_id__volatile)) {
		static const GTypeInfo g_define_type_info = { sizeof (MyIterableIface), (GBaseInitFunc) my_iterable_base_init, (GBaseFinalizeFunc) NULL, (GClassInitFunc) NULL, (GClassFinalizeFunc) NULL, NULL, 0, 0, (GInstanceInitFunc) NULL, NULL };
		GType my_iterable_type_id;
		my_iterable_type_id = g_type_register_static (G_TYPE_INTERFACE, "MyIterable", &g_define_type_info, 0);
		g_type_interface_add_prerequisite (my_iterable_type_id, G_TYPE_OBJECT);
		g_once_init_leave (&my_iterable_type_id__volatile, my_iterable_type_id);
	}
	return my_iterable_type_id__volatile;
}


static gpointer _g_object_ref0 (gpointer self) {
	return self ? g_object_ref (self) : NULL;
}


MyIterator* my_iterator_construct (GType object_type, GType g_type, GBoxedCopyFunc g_dup_func, GDestroyNotify g_destroy_func, MyIList* i) {
	MyIterator* self = NULL;
	MyIList* _tmp0_;
	MyIList* _tmp1_;
	g_return_val_if_fail (i != NULL, NULL);
	self = (MyIterator*) g_type_create_instance (object_type);
	self->priv->g_type = g_type;
	self->priv->g_dup_func = g_dup_func;
	self->priv->g_destroy_func = g_destroy_func;
	_tmp0_ = i;
	_tmp1_ = _g_object_ref0 (_tmp0_);
	_g_object_unref0 (self->priv->iter);
	self->priv->iter = _tmp1_;
	self->priv->index = 0;
	return self;
}


MyIterator* my_iterator_new (GType g_type, GBoxedCopyFunc g_dup_func, GDestroyNotify g_destroy_func, MyIList* i) {
	return my_iterator_construct (MY_TYPE_ITERATOR, g_type, g_dup_func, g_destroy_func, i);
}


gboolean my_iterator_next (MyIterator* self) {
	gboolean result = FALSE;
	gint _tmp0_;
	MyIList* _tmp1_;
	gint _tmp2_;
	gint _tmp3_;
	gint _tmp4_;
	g_return_val_if_fail (self != NULL, FALSE);
	_tmp0_ = self->priv->index;
	_tmp1_ = self->priv->iter;
	_tmp2_ = my_ilist_get_size (_tmp1_);
	_tmp3_ = _tmp2_;
	if (_tmp0_ == _tmp3_) {
		result = FALSE;
		return result;
	}
	_tmp4_ = self->priv->index;
	self->priv->index = _tmp4_ + 1;
	result = TRUE;
	return result;
}


gboolean my_iterator_prev (MyIterator* self) {
	gboolean result = FALSE;
	gint _tmp0_;
	gint _tmp1_;
	g_return_val_if_fail (self != NULL, FALSE);
	_tmp0_ = self->priv->index;
	if (_tmp0_ == 0) {
		result = FALSE;
		return result;
	}
	_tmp1_ = self->priv->index;
	self->priv->index = _tmp1_ - 1;
	result = TRUE;
	return result;
}


gpointer my_iterator_get (MyIterator* self) {
	gpointer result = NULL;
	MyIList* _tmp0_;
	gint _tmp1_;
	gpointer _tmp2_ = NULL;
	g_return_val_if_fail (self != NULL, NULL);
	_tmp0_ = self->priv->iter;
	_tmp1_ = self->priv->index;
	_tmp2_ = my_ilist_get (_tmp0_, _tmp1_);
	result = _tmp2_;
	return result;
}


static void my_value_iterator_init (GValue* value) {
	value->data[0].v_pointer = NULL;
}


static void my_value_iterator_free_value (GValue* value) {
	if (value->data[0].v_pointer) {
		my_iterator_unref (value->data[0].v_pointer);
	}
}


static void my_value_iterator_copy_value (const GValue* src_value, GValue* dest_value) {
	if (src_value->data[0].v_pointer) {
		dest_value->data[0].v_pointer = my_iterator_ref (src_value->data[0].v_pointer);
	} else {
		dest_value->data[0].v_pointer = NULL;
	}
}


static gpointer my_value_iterator_peek_pointer (const GValue* value) {
	return value->data[0].v_pointer;
}


static gchar* my_value_iterator_collect_value (GValue* value, guint n_collect_values, GTypeCValue* collect_values, guint collect_flags) {
	if (collect_values[0].v_pointer) {
		MyIterator* object;
		object = collect_values[0].v_pointer;
		if (object->parent_instance.g_class == NULL) {
			return g_strconcat ("invalid unclassed object pointer for value type `", G_VALUE_TYPE_NAME (value), "'", NULL);
		} else if (!g_value_type_compatible (G_TYPE_FROM_INSTANCE (object), G_VALUE_TYPE (value))) {
			return g_strconcat ("invalid object type `", g_type_name (G_TYPE_FROM_INSTANCE (object)), "' for value type `", G_VALUE_TYPE_NAME (value), "'", NULL);
		}
		value->data[0].v_pointer = my_iterator_ref (object);
	} else {
		value->data[0].v_pointer = NULL;
	}
	return NULL;
}


static gchar* my_value_iterator_lcopy_value (const GValue* value, guint n_collect_values, GTypeCValue* collect_values, guint collect_flags) {
	MyIterator** object_p;
	object_p = collect_values[0].v_pointer;
	if (!object_p) {
		return g_strdup_printf ("value location for `%s' passed as NULL", G_VALUE_TYPE_NAME (value));
	}
	if (!value->data[0].v_pointer) {
		*object_p = NULL;
	} else if (collect_flags & G_VALUE_NOCOPY_CONTENTS) {
		*object_p = value->data[0].v_pointer;
	} else {
		*object_p = my_iterator_ref (value->data[0].v_pointer);
	}
	return NULL;
}


GParamSpec* my_param_spec_iterator (const gchar* name, const gchar* nick, const gchar* blurb, GType object_type, GParamFlags flags) {
	MyParamSpecIterator* spec;
	g_return_val_if_fail (g_type_is_a (object_type, MY_TYPE_ITERATOR), NULL);
	spec = g_param_spec_internal (G_TYPE_PARAM_OBJECT, name, nick, blurb, flags);
	G_PARAM_SPEC (spec)->value_type = object_type;
	return G_PARAM_SPEC (spec);
}


gpointer my_value_get_iterator (const GValue* value) {
	g_return_val_if_fail (G_TYPE_CHECK_VALUE_TYPE (value, MY_TYPE_ITERATOR), NULL);
	return value->data[0].v_pointer;
}


void my_value_set_iterator (GValue* value, gpointer v_object) {
	MyIterator* old;
	g_return_if_fail (G_TYPE_CHECK_VALUE_TYPE (value, MY_TYPE_ITERATOR));
	old = value->data[0].v_pointer;
	if (v_object) {
		g_return_if_fail (G_TYPE_CHECK_INSTANCE_TYPE (v_object, MY_TYPE_ITERATOR));
		g_return_if_fail (g_value_type_compatible (G_TYPE_FROM_INSTANCE (v_object), G_VALUE_TYPE (value)));
		value->data[0].v_pointer = v_object;
		my_iterator_ref (value->data[0].v_pointer);
	} else {
		value->data[0].v_pointer = NULL;
	}
	if (old) {
		my_iterator_unref (old);
	}
}


void my_value_take_iterator (GValue* value, gpointer v_object) {
	MyIterator* old;
	g_return_if_fail (G_TYPE_CHECK_VALUE_TYPE (value, MY_TYPE_ITERATOR));
	old = value->data[0].v_pointer;
	if (v_object) {
		g_return_if_fail (G_TYPE_CHECK_INSTANCE_TYPE (v_object, MY_TYPE_ITERATOR));
		g_return_if_fail (g_value_type_compatible (G_TYPE_FROM_INSTANCE (v_object), G_VALUE_TYPE (value)));
		value->data[0].v_pointer = v_object;
	} else {
		value->data[0].v_pointer = NULL;
	}
	if (old) {
		my_iterator_unref (old);
	}
}


static void my_iterator_class_init (MyIteratorClass * klass) {
	my_iterator_parent_class = g_type_class_peek_parent (klass);
	MY_ITERATOR_CLASS (klass)->finalize = my_iterator_finalize;
	g_type_class_add_private (klass, sizeof (MyIteratorPrivate));
}


static void my_iterator_instance_init (MyIterator * self) {
	self->priv = MY_ITERATOR_GET_PRIVATE (self);
	self->ref_count = 1;
}


static void my_iterator_finalize (MyIterator* obj) {
	MyIterator * self;
	self = G_TYPE_CHECK_INSTANCE_CAST (obj, MY_TYPE_ITERATOR, MyIterator);
	_g_object_unref0 (self->priv->iter);
}


GType my_iterator_get_type (void) {
	static volatile gsize my_iterator_type_id__volatile = 0;
	if (g_once_init_enter (&my_iterator_type_id__volatile)) {
		static const GTypeValueTable g_define_type_value_table = { my_value_iterator_init, my_value_iterator_free_value, my_value_iterator_copy_value, my_value_iterator_peek_pointer, "p", my_value_iterator_collect_value, "p", my_value_iterator_lcopy_value };
		static const GTypeInfo g_define_type_info = { sizeof (MyIteratorClass), (GBaseInitFunc) NULL, (GBaseFinalizeFunc) NULL, (GClassInitFunc) my_iterator_class_init, (GClassFinalizeFunc) NULL, NULL, sizeof (MyIterator), 0, (GInstanceInitFunc) my_iterator_instance_init, &g_define_type_value_table };
		static const GTypeFundamentalInfo g_define_type_fundamental_info = { (G_TYPE_FLAG_CLASSED | G_TYPE_FLAG_INSTANTIATABLE | G_TYPE_FLAG_DERIVABLE | G_TYPE_FLAG_DEEP_DERIVABLE) };
		GType my_iterator_type_id;
		my_iterator_type_id = g_type_register_fundamental (g_type_fundamental_next (), "MyIterator", &g_define_type_info, &g_define_type_fundamental_info, 0);
		g_once_init_leave (&my_iterator_type_id__volatile, my_iterator_type_id);
	}
	return my_iterator_type_id__volatile;
}


gpointer my_iterator_ref (gpointer instance) {
	MyIterator* self;
	self = instance;
	g_atomic_int_inc (&self->ref_count);
	return instance;
}


void my_iterator_unref (gpointer instance) {
	MyIterator* self;
	self = instance;
	if (g_atomic_int_dec_and_test (&self->ref_count)) {
		MY_ITERATOR_GET_CLASS (self)->finalize (self);
		g_type_free_instance ((GTypeInstance *) self);
	}
}



