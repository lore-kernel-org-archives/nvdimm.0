Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 124052095DBB2
 for <linux-nvdimm@lists.01.org>; Tue, 25 Jul 2017 16:53:16 -0700 (PDT)
Date: Tue, 25 Jul 2017 20:55:12 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
Subject: Re: [PATCH 3/4] ndctl: switch to tools/include/linux/{kernel, list,
 bitmap}.h
Message-ID: <20170725235512.GC23846@kernel.org>
References: <150102217021.2258.1380624380896006.stgit@dwillia2-desk3.amr.corp.intel.com>
 <150102218643.2258.15362632812220627446.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <150102218643.2258.15362632812220627446.stgit@dwillia2-desk3.amr.corp.intel.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Em Tue, Jul 25, 2017 at 03:36:26PM -0700, Dan Williams escreveu:
> Replace the ccan implementation of list primitives, bitmap helpers and
> small utility macros with the common definitions available in
> tool/include/linux.

You should first add what you need in separate patches, paving the way
to then use it, and some stuff are already there, see below:
 
> diff --git a/tools/include/linux/hashtable.h b/tools/include/linux/hashtable.h
> index c65cc0aa2659..251eabf2a05e 100644
> --- a/tools/include/linux/hashtable.h
> +++ b/tools/include/linux/hashtable.h
> @@ -13,10 +13,6 @@
>  #include <linux/hash.h>
>  #include <linux/log2.h>
>  
> -#ifndef ARRAY_SIZE
> -#define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
> -#endif
> -

This is already tools/include/linux/kernel.h as

#define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]) + __must_be_array(arr))

It was moved by:

commit 68289cbd83eaa20faef7cc818121bc8e769065de
Author: Arnaldo Carvalho de Melo <acme@redhat.com>
Date:   Mon Apr 17 12:01:36 2017 -0300

    tools include: Drop ARRAY_SIZE() definition from linux/hashtable.h
    
    As tools/include/linux/kernel.h has it now, with the goodies present in
    the kernel.h counterpart, i.e. checking that the parameter is an array
    at build time.

--------------------


>  #define DEFINE_HASHTABLE(name, bits)						\
>  	struct hlist_head name[1 << (bits)] =					\
>  			{ [0 ... ((1 << (bits)) - 1)] = HLIST_HEAD_INIT }
> diff --git a/tools/include/linux/kernel.h b/tools/include/linux/kernel.h
> index 28607db02bd3..ebe5211ce086 100644
> --- a/tools/include/linux/kernel.h
> +++ b/tools/include/linux/kernel.h
> @@ -45,6 +45,10 @@
>  	_min1 < _min2 ? _min1 : _min2; })
>  #endif
>  
> +#ifndef clamp
> +#define clamp(v, f, c) (max(min((v), (c)), (f)))
> +#endif
> +

The include/linux/kernel.h definition is:


/**
 * clamp - return a value clamped to a given range with strict typechecking
 * @val: current value
 * @lo: lowest allowable value
 * @hi: highest allowable value
 *
 * This macro does strict typechecking of lo/hi to make sure they are of the
 * same type as val.  See the unnecessary pointer comparisons.
 */
#define clamp(val, lo, hi) min((typeof(val))max(val, lo), hi)

I suggest we try to track the kernel counterparts as much as possible, and
put the definitions in the same order as in the kernel header, this way we
can even look at how different they are using plain old 'diff'.

>  #ifndef roundup
>  #define roundup(x, y) (                                \
>  {                                                      \
> @@ -54,6 +58,10 @@
>  )
>  #endif
>  
> +#ifndef ARRAY_SIZE
> +#define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
> +#endif
> +
>  #ifndef BUG_ON
>  #ifdef NDEBUG
>  #define BUG_ON(cond) do { if (cond) {} } while (0)
> @@ -66,8 +74,10 @@
>   * Both need more care to handle endianness
>   * (Don't use bitmap_copy_le() for now)
>   */
> +#ifndef cpu_to_le64
>  #define cpu_to_le64(x)	(x)
>  #define cpu_to_le32(x)	(x)
> +#endif

This will not apply, there were changes here as well.
  
>  int vscnprintf(char *buf, size_t size, const char *fmt, va_list args);
>  int scnprintf(char * buf, size_t size, const char * fmt, ...);
> diff --git a/tools/ndctl/Makefile.am b/tools/ndctl/Makefile.am
> index ba81e8c3d5bb..2803ec51a0b2 100644
> --- a/tools/ndctl/Makefile.am
> +++ b/tools/ndctl/Makefile.am
> @@ -48,18 +48,15 @@ libccan_a_SOURCES = \
>  	ccan/str/str_debug.h \
>  	ccan/str/str.c \
>  	ccan/str/debug.c \
> -	ccan/list/list.h \
> -	ccan/list/list.c \
>  	ccan/container_of/container_of.h \
>  	ccan/check_type/check_type.h \
>  	ccan/build_assert/build_assert.h \
> -	ccan/array_size/array_size.h \
> -	ccan/minmax/minmax.h \
>  	ccan/short_types/short_types.h \
>  	ccan/endian/endian.h
>  
>  noinst_LIBRARIES += libutil.a
>  libutil_a_SOURCES = \
> +	../lib/find_bit.c \
>  	util/parse-options.c \
>  	util/parse-options.h \
>  	util/usage.c \
> @@ -69,7 +66,6 @@ libutil_a_SOURCES = \
>  	util/strbuf.c \
>  	util/wrapper.c \
>  	util/filter.c \
> -	util/fletcher.c\
> -	util/bitmap.c
> +	util/fletcher.c
>  
>  nobase_include_HEADERS = daxctl/libdaxctl.h
> diff --git a/tools/ndctl/Makefile.am.in b/tools/ndctl/Makefile.am.in
> index 9cb8d4a055c7..1680b738578d 100644
> --- a/tools/ndctl/Makefile.am.in
> +++ b/tools/ndctl/Makefile.am.in
> @@ -9,6 +9,7 @@ AM_CPPFLAGS = \
>  	-DLIBEXECDIR=\""$(libexecdir)"\" \
>  	-DPREFIX=\""$(prefix)"\" \
>  	-DNDCTL_MAN_PATH=\""$(mandir)"\" \
> +	-I${top_srcdir}/../include \
>  	-I${top_srcdir}/ndctl/lib \
>  	-I${top_srcdir}/ndctl \
>  	-I${top_srcdir}/ \
> diff --git a/tools/ndctl/ccan/array_size/LICENSE b/tools/ndctl/ccan/array_size/LICENSE
> deleted file mode 120000
> index b7951dabdc82..000000000000
> --- a/tools/ndctl/ccan/array_size/LICENSE
> +++ /dev/null
> @@ -1 +0,0 @@
> -../../licenses/CC0
> \ No newline at end of file
> diff --git a/tools/ndctl/ccan/array_size/array_size.h b/tools/ndctl/ccan/array_size/array_size.h
> deleted file mode 100644
> index 0ca422a29168..000000000000
> --- a/tools/ndctl/ccan/array_size/array_size.h
> +++ /dev/null
> @@ -1,26 +0,0 @@
> -/* CC0 (Public domain) - see LICENSE file for details */
> -#ifndef CCAN_ARRAY_SIZE_H
> -#define CCAN_ARRAY_SIZE_H
> -#include "config.h"
> -#include <ccan/build_assert/build_assert.h>
> -
> -/**
> - * ARRAY_SIZE - get the number of elements in a visible array
> - * @arr: the array whose size you want.
> - *
> - * This does not work on pointers, or arrays declared as [], or
> - * function parameters.  With correct compiler support, such usage
> - * will cause a build error (see build_assert).
> - */
> -#define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]) + _array_size_chk(arr))
> -
> -#if HAVE_BUILTIN_TYPES_COMPATIBLE_P && HAVE_TYPEOF
> -/* Two gcc extensions.
> - * &a[0] degrades to a pointer: a different type from an array */
> -#define _array_size_chk(arr)						\
> -	BUILD_ASSERT_OR_ZERO(!__builtin_types_compatible_p(typeof(arr),	\
> -							typeof(&(arr)[0])))
> -#else
> -#define _array_size_chk(arr) 0
> -#endif
> -#endif /* CCAN_ALIGNOF_H */
> diff --git a/tools/ndctl/ccan/container_of/LICENSE b/tools/ndctl/ccan/container_of/LICENSE
> deleted file mode 120000
> index b7951dabdc82..000000000000
> --- a/tools/ndctl/ccan/container_of/LICENSE
> +++ /dev/null
> @@ -1 +0,0 @@
> -../../licenses/CC0
> \ No newline at end of file
> diff --git a/tools/ndctl/ccan/container_of/container_of.h b/tools/ndctl/ccan/container_of/container_of.h
> deleted file mode 100644
> index 0449935056f5..000000000000
> --- a/tools/ndctl/ccan/container_of/container_of.h
> +++ /dev/null
> @@ -1,109 +0,0 @@
> -/* CC0 (Public domain) - see LICENSE file for details */
> -#ifndef CCAN_CONTAINER_OF_H
> -#define CCAN_CONTAINER_OF_H
> -#include <stddef.h>
> -
> -#include "config.h"
> -#include <ccan/check_type/check_type.h>
> -
> -/**
> - * container_of - get pointer to enclosing structure
> - * @member_ptr: pointer to the structure member
> - * @containing_type: the type this member is within
> - * @member: the name of this member within the structure.
> - *
> - * Given a pointer to a member of a structure, this macro does pointer
> - * subtraction to return the pointer to the enclosing type.
> - *
> - * Example:
> - *	struct foo {
> - *		int fielda, fieldb;
> - *		// ...
> - *	};
> - *	struct info {
> - *		int some_other_field;
> - *		struct foo my_foo;
> - *	};
> - *
> - *	static struct info *foo_to_info(struct foo *foo)
> - *	{
> - *		return container_of(foo, struct info, my_foo);
> - *	}
> - */
> -#define container_of(member_ptr, containing_type, member)		\
> -	 ((containing_type *)						\
> -	  ((char *)(member_ptr)						\
> -	   - container_off(containing_type, member))			\
> -	  + check_types_match(*(member_ptr), ((containing_type *)0)->member))
> -
> -/**
> - * container_off - get offset to enclosing structure
> - * @containing_type: the type this member is within
> - * @member: the name of this member within the structure.
> - *
> - * Given a pointer to a member of a structure, this macro does
> - * typechecking and figures out the offset to the enclosing type.
> - *
> - * Example:
> - *	struct foo {
> - *		int fielda, fieldb;
> - *		// ...
> - *	};
> - *	struct info {
> - *		int some_other_field;
> - *		struct foo my_foo;
> - *	};
> - *
> - *	static struct info *foo_to_info(struct foo *foo)
> - *	{
> - *		size_t off = container_off(struct info, my_foo);
> - *		return (void *)((char *)foo - off);
> - *	}
> - */
> -#define container_off(containing_type, member)	\
> -	offsetof(containing_type, member)
> -
> -/**
> - * container_of_var - get pointer to enclosing structure using a variable
> - * @member_ptr: pointer to the structure member
> - * @container_var: a pointer of same type as this member's container
> - * @member: the name of this member within the structure.
> - *
> - * Given a pointer to a member of a structure, this macro does pointer
> - * subtraction to return the pointer to the enclosing type.
> - *
> - * Example:
> - *	static struct info *foo_to_i(struct foo *foo)
> - *	{
> - *		struct info *i = container_of_var(foo, i, my_foo);
> - *		return i;
> - *	}
> - */
> -#if HAVE_TYPEOF
> -#define container_of_var(member_ptr, container_var, member) \
> -	container_of(member_ptr, typeof(*container_var), member)
> -#else
> -#define container_of_var(member_ptr, container_var, member)	\
> -	((void *)((char *)(member_ptr)	-			\
> -		  container_off_var(container_var, member)))
> -#endif
> -
> -/**
> - * container_off_var - get offset of a field in enclosing structure
> - * @container_var: a pointer to a container structure
> - * @member: the name of a member within the structure.
> - *
> - * Given (any) pointer to a structure and a its member name, this
> - * macro does pointer subtraction to return offset of member in a
> - * structure memory layout.
> - *
> - */
> -#if HAVE_TYPEOF
> -#define container_off_var(var, member)		\
> -	container_off(typeof(*var), member)
> -#else
> -#define container_off_var(var, member)			\
> -	((const char *)&(var)->member - (const char *)(var))
> -#endif
> -
> -#endif /* CCAN_CONTAINER_OF_H */
> diff --git a/tools/ndctl/ccan/list/LICENSE b/tools/ndctl/ccan/list/LICENSE
> deleted file mode 120000
> index 2354d12945d3..000000000000
> --- a/tools/ndctl/ccan/list/LICENSE
> +++ /dev/null
> @@ -1 +0,0 @@
> -../../licenses/BSD-MIT
> \ No newline at end of file
> diff --git a/tools/ndctl/ccan/list/list.c b/tools/ndctl/ccan/list/list.c
> deleted file mode 100644
> index 2717fa3f17e5..000000000000
> --- a/tools/ndctl/ccan/list/list.c
> +++ /dev/null
> @@ -1,43 +0,0 @@
> -/* Licensed under BSD-MIT - see LICENSE file for details */
> -#include <stdio.h>
> -#include <stdlib.h>
> -#include "list.h"
> -
> -static void *corrupt(const char *abortstr,
> -		     const struct list_node *head,
> -		     const struct list_node *node,
> -		     unsigned int count)
> -{
> -	if (abortstr) {
> -		fprintf(stderr,
> -			"%s: prev corrupt in node %p (%u) of %p\n",
> -			abortstr, node, count, head);
> -		abort();
> -	}
> -	return NULL;
> -}
> -
> -struct list_node *list_check_node(const struct list_node *node,
> -				  const char *abortstr)
> -{
> -	const struct list_node *p, *n;
> -	int count = 0;
> -
> -	for (p = node, n = node->next; n != node; p = n, n = n->next) {
> -		count++;
> -		if (n->prev != p)
> -			return corrupt(abortstr, node, n, count);
> -	}
> -	/* Check prev on head node. */
> -	if (node->prev != p)
> -		return corrupt(abortstr, node, node, 0);
> -
> -	return (struct list_node *)node;
> -}
> -
> -struct list_head *list_check(const struct list_head *h, const char *abortstr)
> -{
> -	if (!list_check_node(&h->n, abortstr))
> -		return NULL;
> -	return (struct list_head *)h;
> -}
> diff --git a/tools/ndctl/ccan/list/list.h b/tools/ndctl/ccan/list/list.h
> deleted file mode 100644
> index 4d1d34e32709..000000000000
> --- a/tools/ndctl/ccan/list/list.h
> +++ /dev/null
> @@ -1,656 +0,0 @@
> -/* Licensed under BSD-MIT - see LICENSE file for details */
> -#ifndef CCAN_LIST_H
> -#define CCAN_LIST_H
> -//#define CCAN_LIST_DEBUG 1
> -#include <stdbool.h>
> -#include <assert.h>
> -#include <ccan/str/str.h>
> -#include <ccan/container_of/container_of.h>
> -#include <ccan/check_type/check_type.h>
> -
> -/**
> - * struct list_node - an entry in a doubly-linked list
> - * @next: next entry (self if empty)
> - * @prev: previous entry (self if empty)
> - *
> - * This is used as an entry in a linked list.
> - * Example:
> - *	struct child {
> - *		const char *name;
> - *		// Linked list of all us children.
> - *		struct list_node list;
> - *	};
> - */
> -struct list_node
> -{
> -	struct list_node *next, *prev;
> -};
> -
> -/**
> - * struct list_head - the head of a doubly-linked list
> - * @h: the list_head (containing next and prev pointers)
> - *
> - * This is used as the head of a linked list.
> - * Example:
> - *	struct parent {
> - *		const char *name;
> - *		struct list_head children;
> - *		unsigned int num_children;
> - *	};
> - */
> -struct list_head
> -{
> -	struct list_node n;
> -};
> -
> -/**
> - * list_check - check head of a list for consistency
> - * @h: the list_head
> - * @abortstr: the location to print on aborting, or NULL.
> - *
> - * Because list_nodes have redundant information, consistency checking between
> - * the back and forward links can be done.  This is useful as a debugging check.
> - * If @abortstr is non-NULL, that will be printed in a diagnostic if the list
> - * is inconsistent, and the function will abort.
> - *
> - * Returns the list head if the list is consistent, NULL if not (it
> - * can never return NULL if @abortstr is set).
> - *
> - * See also: list_check_node()
> - *
> - * Example:
> - *	static void dump_parent(struct parent *p)
> - *	{
> - *		struct child *c;
> - *
> - *		printf("%s (%u children):\n", p->name, p->num_children);
> - *		list_check(&p->children, "bad child list");
> - *		list_for_each(&p->children, c, list)
> - *			printf(" -> %s\n", c->name);
> - *	}
> - */
> -struct list_head *list_check(const struct list_head *h, const char *abortstr);
> -
> -/**
> - * list_check_node - check node of a list for consistency
> - * @n: the list_node
> - * @abortstr: the location to print on aborting, or NULL.
> - *
> - * Check consistency of the list node is in (it must be in one).
> - *
> - * See also: list_check()
> - *
> - * Example:
> - *	static void dump_child(const struct child *c)
> - *	{
> - *		list_check_node(&c->list, "bad child list");
> - *		printf("%s\n", c->name);
> - *	}
> - */
> -struct list_node *list_check_node(const struct list_node *n,
> -				  const char *abortstr);
> -
> -#define LIST_LOC __FILE__  ":" stringify(__LINE__)
> -#ifdef CCAN_LIST_DEBUG
> -#define list_debug(h, loc) list_check((h), loc)
> -#define list_debug_node(n, loc) list_check_node((n), loc)
> -#else
> -#define list_debug(h, loc) (h)
> -#define list_debug_node(n, loc) (n)
> -#endif
> -
> -/**
> - * LIST_HEAD_INIT - initializer for an empty list_head
> - * @name: the name of the list.
> - *
> - * Explicit initializer for an empty list.
> - *
> - * See also:
> - *	LIST_HEAD, list_head_init()
> - *
> - * Example:
> - *	static struct list_head my_list = LIST_HEAD_INIT(my_list);
> - */
> -#define LIST_HEAD_INIT(name) { { &name.n, &name.n } }
> -
> -/**
> - * LIST_HEAD - define and initialize an empty list_head
> - * @name: the name of the list.
> - *
> - * The LIST_HEAD macro defines a list_head and initializes it to an empty
> - * list.  It can be prepended by "static" to define a static list_head.
> - *
> - * See also:
> - *	LIST_HEAD_INIT, list_head_init()
> - *
> - * Example:
> - *	static LIST_HEAD(my_global_list);
> - */
> -#define LIST_HEAD(name) \
> -	struct list_head name = LIST_HEAD_INIT(name)
> -
> -/**
> - * list_head_init - initialize a list_head
> - * @h: the list_head to set to the empty list
> - *
> - * Example:
> - *	...
> - *	struct parent *parent = malloc(sizeof(*parent));
> - *
> - *	list_head_init(&parent->children);
> - *	parent->num_children = 0;
> - */
> -static inline void list_head_init(struct list_head *h)
> -{
> -	h->n.next = h->n.prev = &h->n;
> -}
> -
> -/**
> - * list_add - add an entry at the start of a linked list.
> - * @h: the list_head to add the node to
> - * @n: the list_node to add to the list.
> - *
> - * The list_node does not need to be initialized; it will be overwritten.
> - * Example:
> - *	struct child *child = malloc(sizeof(*child));
> - *
> - *	child->name = "marvin";
> - *	list_add(&parent->children, &child->list);
> - *	parent->num_children++;
> - */
> -#define list_add(h, n) list_add_(h, n, LIST_LOC)
> -static inline void list_add_(struct list_head *h,
> -			     struct list_node *n,
> -			     const char *abortstr)
> -{
> -	n->next = h->n.next;
> -	n->prev = &h->n;
> -	h->n.next->prev = n;
> -	h->n.next = n;
> -	(void)list_debug(h, abortstr);
> -}
> -
> -/**
> - * list_add_tail - add an entry at the end of a linked list.
> - * @h: the list_head to add the node to
> - * @n: the list_node to add to the list.
> - *
> - * The list_node does not need to be initialized; it will be overwritten.
> - * Example:
> - *	list_add_tail(&parent->children, &child->list);
> - *	parent->num_children++;
> - */
> -#define list_add_tail(h, n) list_add_tail_(h, n, LIST_LOC)
> -static inline void list_add_tail_(struct list_head *h,
> -				  struct list_node *n,
> -				  const char *abortstr)
> -{
> -	n->next = &h->n;
> -	n->prev = h->n.prev;
> -	h->n.prev->next = n;
> -	h->n.prev = n;
> -	(void)list_debug(h, abortstr);
> -}
> -
> -/**
> - * list_empty - is a list empty?
> - * @h: the list_head
> - *
> - * If the list is empty, returns true.
> - *
> - * Example:
> - *	assert(list_empty(&parent->children) == (parent->num_children == 0));
> - */
> -#define list_empty(h) list_empty_(h, LIST_LOC)
> -static inline bool list_empty_(const struct list_head *h, const char* abortstr)
> -{
> -	(void)list_debug(h, abortstr);
> -	return h->n.next == &h->n;
> -}
> -
> -/**
> - * list_empty_nodebug - is a list empty (and don't perform debug checks)?
> - * @h: the list_head
> - *
> - * If the list is empty, returns true.
> - * This differs from list_empty() in that if CCAN_LIST_DEBUG is set it
> - * will NOT perform debug checks. Only use this function if you REALLY
> - * know what you're doing.
> - *
> - * Example:
> - *	assert(list_empty_nodebug(&parent->children) == (parent->num_children == 0));
> - */
> -#ifndef CCAN_LIST_DEBUG
> -#define list_empty_nodebug(h) list_empty(h)
> -#else
> -static inline bool list_empty_nodebug(const struct list_head *h)
> -{
> -	return h->n.next == &h->n;
> -}
> -#endif
> -
> -/**
> - * list_del - delete an entry from an (unknown) linked list.
> - * @n: the list_node to delete from the list.
> - *
> - * Note that this leaves @n in an undefined state; it can be added to
> - * another list, but not deleted again.
> - *
> - * See also:
> - *	list_del_from()
> - *
> - * Example:
> - *	list_del(&child->list);
> - *	parent->num_children--;
> - */
> -#define list_del(n) list_del_(n, LIST_LOC)
> -static inline void list_del_(struct list_node *n, const char* abortstr)
> -{
> -	(void)list_debug_node(n, abortstr);
> -	n->next->prev = n->prev;
> -	n->prev->next = n->next;
> -#ifdef CCAN_LIST_DEBUG
> -	/* Catch use-after-del. */
> -	n->next = n->prev = NULL;
> -#endif
> -}
> -
> -/**
> - * list_del_from - delete an entry from a known linked list.
> - * @h: the list_head the node is in.
> - * @n: the list_node to delete from the list.
> - *
> - * This explicitly indicates which list a node is expected to be in,
> - * which is better documentation and can catch more bugs.
> - *
> - * See also: list_del()
> - *
> - * Example:
> - *	list_del_from(&parent->children, &child->list);
> - *	parent->num_children--;
> - */
> -static inline void list_del_from(struct list_head *h, struct list_node *n)
> -{
> -#ifdef CCAN_LIST_DEBUG
> -	{
> -		/* Thorough check: make sure it was in list! */
> -		struct list_node *i;
> -		for (i = h->n.next; i != n; i = i->next)
> -			assert(i != &h->n);
> -	}
> -#endif /* CCAN_LIST_DEBUG */
> -
> -	/* Quick test that catches a surprising number of bugs. */
> -	assert(!list_empty(h));
> -	list_del(n);
> -}
> -
> -/**
> - * list_entry - convert a list_node back into the structure containing it.
> - * @n: the list_node
> - * @type: the type of the entry
> - * @member: the list_node member of the type
> - *
> - * Example:
> - *	// First list entry is children.next; convert back to child.
> - *	child = list_entry(parent->children.n.next, struct child, list);
> - *
> - * See Also:
> - *	list_top(), list_for_each()
> - */
> -#define list_entry(n, type, member) container_of(n, type, member)
> -
> -/**
> - * list_top - get the first entry in a list
> - * @h: the list_head
> - * @type: the type of the entry
> - * @member: the list_node member of the type
> - *
> - * If the list is empty, returns NULL.
> - *
> - * Example:
> - *	struct child *first;
> - *	first = list_top(&parent->children, struct child, list);
> - *	if (!first)
> - *		printf("Empty list!\n");
> - */
> -#define list_top(h, type, member)					\
> -	((type *)list_top_((h), list_off_(type, member)))
> -
> -static inline const void *list_top_(const struct list_head *h, size_t off)
> -{
> -	if (list_empty(h))
> -		return NULL;
> -	return (const char *)h->n.next - off;
> -}
> -
> -/**
> - * list_pop - remove the first entry in a list
> - * @h: the list_head
> - * @type: the type of the entry
> - * @member: the list_node member of the type
> - *
> - * If the list is empty, returns NULL.
> - *
> - * Example:
> - *	struct child *one;
> - *	one = list_pop(&parent->children, struct child, list);
> - *	if (!one)
> - *		printf("Empty list!\n");
> - */
> -#define list_pop(h, type, member)					\
> -	((type *)list_pop_((h), list_off_(type, member)))
> -
> -static inline const void *list_pop_(const struct list_head *h, size_t off)
> -{
> -	struct list_node *n;
> -
> -	if (list_empty(h))
> -		return NULL;
> -	n = h->n.next;
> -	list_del(n);
> -	return (const char *)n - off;
> -}
> -
> -/**
> - * list_tail - get the last entry in a list
> - * @h: the list_head
> - * @type: the type of the entry
> - * @member: the list_node member of the type
> - *
> - * If the list is empty, returns NULL.
> - *
> - * Example:
> - *	struct child *last;
> - *	last = list_tail(&parent->children, struct child, list);
> - *	if (!last)
> - *		printf("Empty list!\n");
> - */
> -#define list_tail(h, type, member) \
> -	((type *)list_tail_((h), list_off_(type, member)))
> -
> -static inline const void *list_tail_(const struct list_head *h, size_t off)
> -{
> -	if (list_empty(h))
> -		return NULL;
> -	return (const char *)h->n.prev - off;
> -}
> -
> -/**
> - * list_for_each - iterate through a list.
> - * @h: the list_head (warning: evaluated multiple times!)
> - * @i: the structure containing the list_node
> - * @member: the list_node member of the structure
> - *
> - * This is a convenient wrapper to iterate @i over the entire list.  It's
> - * a for loop, so you can break and continue as normal.
> - *
> - * Example:
> - *	list_for_each(&parent->children, child, list)
> - *		printf("Name: %s\n", child->name);
> - */
> -#define list_for_each(h, i, member)					\
> -	list_for_each_off(h, i, list_off_var_(i, member))
> -
> -/**
> - * list_for_each_rev - iterate through a list backwards.
> - * @h: the list_head
> - * @i: the structure containing the list_node
> - * @member: the list_node member of the structure
> - *
> - * This is a convenient wrapper to iterate @i over the entire list.  It's
> - * a for loop, so you can break and continue as normal.
> - *
> - * Example:
> - *	list_for_each_rev(&parent->children, child, list)
> - *		printf("Name: %s\n", child->name);
> - */
> -#define list_for_each_rev(h, i, member)					\
> -	for (i = container_of_var(list_debug(h,	LIST_LOC)->n.prev, i, member); \
> -	     &i->member != &(h)->n;					\
> -	     i = container_of_var(i->member.prev, i, member))
> -
> -/**
> - * list_for_each_safe - iterate through a list, maybe during deletion
> - * @h: the list_head
> - * @i: the structure containing the list_node
> - * @nxt: the structure containing the list_node
> - * @member: the list_node member of the structure
> - *
> - * This is a convenient wrapper to iterate @i over the entire list.  It's
> - * a for loop, so you can break and continue as normal.  The extra variable
> - * @nxt is used to hold the next element, so you can delete @i from the list.
> - *
> - * Example:
> - *	struct child *next;
> - *	list_for_each_safe(&parent->children, child, next, list) {
> - *		list_del(&child->list);
> - *		parent->num_children--;
> - *	}
> - */
> -#define list_for_each_safe(h, i, nxt, member)				\
> -	list_for_each_safe_off(h, i, nxt, list_off_var_(i, member))
> -
> -/**
> - * list_next - get the next entry in a list
> - * @h: the list_head
> - * @i: a pointer to an entry in the list.
> - * @member: the list_node member of the structure
> - *
> - * If @i was the last entry in the list, returns NULL.
> - *
> - * Example:
> - *	struct child *second;
> - *	second = list_next(&parent->children, first, list);
> - *	if (!second)
> - *		printf("No second child!\n");
> - */
> -#define list_next(h, i, member)						\
> -	((list_typeof(i))list_entry_or_null(list_debug(h,		\
> -					    __FILE__ ":" stringify(__LINE__)), \
> -					    (i)->member.next,		\
> -					    list_off_var_((i), member)))
> -
> -/**
> - * list_prev - get the previous entry in a list
> - * @h: the list_head
> - * @i: a pointer to an entry in the list.
> - * @member: the list_node member of the structure
> - *
> - * If @i was the first entry in the list, returns NULL.
> - *
> - * Example:
> - *	first = list_prev(&parent->children, second, list);
> - *	if (!first)
> - *		printf("Can't go back to first child?!\n");
> - */
> -#define list_prev(h, i, member)						\
> -	((list_typeof(i))list_entry_or_null(list_debug(h,		\
> -					    __FILE__ ":" stringify(__LINE__)), \
> -					    (i)->member.prev,		\
> -					    list_off_var_((i), member)))
> -
> -/**
> - * list_append_list - empty one list onto the end of another.
> - * @to: the list to append into
> - * @from: the list to empty.
> - *
> - * This takes the entire contents of @from and moves it to the end of
> - * @to.  After this @from will be empty.
> - *
> - * Example:
> - *	struct list_head adopter;
> - *
> - *	list_append_list(&adopter, &parent->children);
> - *	assert(list_empty(&parent->children));
> - *	parent->num_children = 0;
> - */
> -#define list_append_list(t, f) list_append_list_(t, f,			\
> -				   __FILE__ ":" stringify(__LINE__))
> -static inline void list_append_list_(struct list_head *to,
> -				     struct list_head *from,
> -				     const char *abortstr)
> -{
> -	struct list_node *from_tail = list_debug(from, abortstr)->n.prev;
> -	struct list_node *to_tail = list_debug(to, abortstr)->n.prev;
> -
> -	/* Sew in head and entire list. */
> -	to->n.prev = from_tail;
> -	from_tail->next = &to->n;
> -	to_tail->next = &from->n;
> -	from->n.prev = to_tail;
> -
> -	/* Now remove head. */
> -	list_del(&from->n);
> -	list_head_init(from);
> -}
> -
> -/**
> - * list_prepend_list - empty one list into the start of another.
> - * @to: the list to prepend into
> - * @from: the list to empty.
> - *
> - * This takes the entire contents of @from and moves it to the start
> - * of @to.  After this @from will be empty.
> - *
> - * Example:
> - *	list_prepend_list(&adopter, &parent->children);
> - *	assert(list_empty(&parent->children));
> - *	parent->num_children = 0;
> - */
> -#define list_prepend_list(t, f) list_prepend_list_(t, f, LIST_LOC)
> -static inline void list_prepend_list_(struct list_head *to,
> -				      struct list_head *from,
> -				      const char *abortstr)
> -{
> -	struct list_node *from_tail = list_debug(from, abortstr)->n.prev;
> -	struct list_node *to_head = list_debug(to, abortstr)->n.next;
> -
> -	/* Sew in head and entire list. */
> -	to->n.next = &from->n;
> -	from->n.prev = &to->n;
> -	to_head->prev = from_tail;
> -	from_tail->next = to_head;
> -
> -	/* Now remove head. */
> -	list_del(&from->n);
> -	list_head_init(from);
> -}
> -
> -/**
> - * list_for_each_off - iterate through a list of memory regions.
> - * @h: the list_head
> - * @i: the pointer to a memory region wich contains list node data.
> - * @off: offset(relative to @i) at which list node data resides.
> - *
> - * This is a low-level wrapper to iterate @i over the entire list, used to
> - * implement all oher, more high-level, for-each constructs. It's a for loop,
> - * so you can break and continue as normal.
> - *
> - * WARNING! Being the low-level macro that it is, this wrapper doesn't know
> - * nor care about the type of @i. The only assumtion made is that @i points
> - * to a chunk of memory that at some @offset, relative to @i, contains a
> - * properly filled `struct node_list' which in turn contains pointers to
> - * memory chunks and it's turtles all the way down. Whith all that in mind
> - * remember that given the wrong pointer/offset couple this macro will
> - * happilly churn all you memory untill SEGFAULT stops it, in other words
> - * caveat emptor.
> - *
> - * It is worth mentioning that one of legitimate use-cases for that wrapper
> - * is operation on opaque types with known offset for `struct list_node'
> - * member(preferably 0), because it allows you not to disclose the type of
> - * @i.
> - *
> - * Example:
> - *	list_for_each_off(&parent->children, child,
> - *				offsetof(struct child, list))
> - *		printf("Name: %s\n", child->name);
> - */
> -#define list_for_each_off(h, i, off)                                    \
> -	for (i = list_node_to_off_(list_debug(h, LIST_LOC)->n.next,	\
> -				   (off));				\
> -       list_node_from_off_((void *)i, (off)) != &(h)->n;                \
> -       i = list_node_to_off_(list_node_from_off_((void *)i, (off))->next, \
> -                             (off)))
> -
> -/**
> - * list_for_each_safe_off - iterate through a list of memory regions, maybe
> - * during deletion
> - * @h: the list_head
> - * @i: the pointer to a memory region wich contains list node data.
> - * @nxt: the structure containing the list_node
> - * @off: offset(relative to @i) at which list node data resides.
> - *
> - * For details see `list_for_each_off' and `list_for_each_safe'
> - * descriptions.
> - *
> - * Example:
> - *	list_for_each_safe_off(&parent->children, child,
> - *		next, offsetof(struct child, list))
> - *		printf("Name: %s\n", child->name);
> - */
> -#define list_for_each_safe_off(h, i, nxt, off)                          \
> -	for (i = list_node_to_off_(list_debug(h, LIST_LOC)->n.next,	\
> -				   (off)),				\
> -         nxt = list_node_to_off_(list_node_from_off_(i, (off))->next,   \
> -                                 (off));                                \
> -       list_node_from_off_(i, (off)) != &(h)->n;                        \
> -       i = nxt,                                                         \
> -         nxt = list_node_to_off_(list_node_from_off_(i, (off))->next,   \
> -                                 (off)))
> -
> -
> -/* Other -off variants. */
> -#define list_entry_off(n, type, off)		\
> -	((type *)list_node_from_off_((n), (off)))
> -
> -#define list_head_off(h, type, off)		\
> -	((type *)list_head_off((h), (off)))
> -
> -#define list_tail_off(h, type, off)		\
> -	((type *)list_tail_((h), (off)))
> -
> -#define list_add_off(h, n, off)                 \
> -	list_add((h), list_node_from_off_((n), (off)))
> -
> -#define list_del_off(n, off)                    \
> -	list_del(list_node_from_off_((n), (off)))
> -
> -#define list_del_from_off(h, n, off)			\
> -	list_del_from(h, list_node_from_off_((n), (off)))
> -
> -/* Offset helper functions so we only single-evaluate. */
> -static inline void *list_node_to_off_(struct list_node *node, size_t off)
> -{
> -	return (void *)((char *)node - off);
> -}
> -static inline struct list_node *list_node_from_off_(void *ptr, size_t off)
> -{
> -	return (struct list_node *)((char *)ptr + off);
> -}
> -
> -/* Get the offset of the member, but make sure it's a list_node. */
> -#define list_off_(type, member)					\
> -	(container_off(type, member) +				\
> -	 check_type(((type *)0)->member, struct list_node))
> -
> -#define list_off_var_(var, member)			\
> -	(container_off_var(var, member) +		\
> -	 check_type(var->member, struct list_node))
> -
> -#if HAVE_TYPEOF
> -#define list_typeof(var) typeof(var)
> -#else
> -#define list_typeof(var) void *
> -#endif
> -
> -/* Returns member, or NULL if at end of list. */
> -static inline void *list_entry_or_null(const struct list_head *h,
> -				       const struct list_node *n,
> -				       size_t off)
> -{
> -	if (n == &h->n)
> -		return NULL;
> -	return (char *)n - off;
> -}
> -#endif /* CCAN_LIST_H */
> diff --git a/tools/ndctl/ccan/minmax/LICENSE b/tools/ndctl/ccan/minmax/LICENSE
> deleted file mode 120000
> index b7951dabdc82..000000000000
> --- a/tools/ndctl/ccan/minmax/LICENSE
> +++ /dev/null
> @@ -1 +0,0 @@
> -../../licenses/CC0
> \ No newline at end of file
> diff --git a/tools/ndctl/ccan/minmax/minmax.h b/tools/ndctl/ccan/minmax/minmax.h
> deleted file mode 100644
> index 54f246cc112d..000000000000
> --- a/tools/ndctl/ccan/minmax/minmax.h
> +++ /dev/null
> @@ -1,65 +0,0 @@
> -/* CC0 (Public domain) - see LICENSE file for details */
> -#ifndef CCAN_MINMAX_H
> -#define CCAN_MINMAX_H
> -
> -#include "config.h"
> -
> -#include <ccan/build_assert/build_assert.h>
> -
> -#if !HAVE_STATEMENT_EXPR || !HAVE_TYPEOF
> -/*
> - * Without these, there's no way to avoid unsafe double evaluation of
> - * the arguments
> - */
> -#error Sorry, minmax module requires statement expressions and typeof
> -#endif
> -
> -#if HAVE_BUILTIN_TYPES_COMPATIBLE_P
> -#define MINMAX_ASSERT_COMPATIBLE(a, b) \
> -	BUILD_ASSERT(__builtin_types_compatible_p(a, b))
> -#else
> -#define MINMAX_ASSERT_COMPATIBLE(a, b) \
> -	do { } while (0)
> -#endif
> -
> -#define min(a, b) \
> -	({ \
> -		typeof(a) _a = (a); \
> -		typeof(b) _b = (b); \
> -		MINMAX_ASSERT_COMPATIBLE(typeof(_a), typeof(_b)); \
> -		_a < _b ? _a : _b; \
> -	})
> -
> -#define max(a, b) \
> -	({ \
> -		typeof(a) __a = (a); \
> -		typeof(b) __b = (b); \
> -		MINMAX_ASSERT_COMPATIBLE(typeof(__a), typeof(__b)); \
> -		__a > __b ? __a : __b; \
> -	})
> -
> -#define clamp(v, f, c)	(max(min((v), (c)), (f)))
> -
> -
> -#define min_t(t, a, b) \
> -	({ \
> -		t _ta = (a); \
> -		t _tb = (b); \
> -		min(_ta, _tb); \
> -	})
> -#define max_t(t, a, b) \
> -	({ \
> -		t _ta = (a); \
> -		t _tb = (b); \
> -		max(_ta, _tb); \
> -	})
> -
> -#define clamp_t(t, v, f, c) \
> -	({ \
> -		t _tv = (v); \
> -		t _tf = (f); \
> -		t _tc = (c); \
> -		clamp(_tv, _tf, _tc); \
> -	})
> -
> -#endif /* CCAN_MINMAX_H */
> diff --git a/tools/ndctl/configure.ac b/tools/ndctl/configure.ac
> index 316f5b7c8b75..175202e4d8df 100644
> --- a/tools/ndctl/configure.ac
> +++ b/tools/ndctl/configure.ac
> @@ -249,7 +249,6 @@ my_CFLAGS="\
>  -Wmissing-declarations \
>  -Wmissing-prototypes \
>  -Wnested-externs \
> --Wpointer-arith \
>  -Wshadow \
>  -Wsign-compare \
>  -Wstrict-prototypes \
> diff --git a/tools/ndctl/daxctl/daxctl.c b/tools/ndctl/daxctl/daxctl.c
> index 91a4600e262f..e055d825d5e4 100644
> --- a/tools/ndctl/daxctl/daxctl.c
> +++ b/tools/ndctl/daxctl/daxctl.c
> @@ -21,9 +21,9 @@
>  #include <unistd.h>
>  #include <sys/stat.h>
>  #include <sys/types.h>
> +#include <util/kernel.h>
>  #include <daxctl/libdaxctl.h>
>  #include <util/parse-options.h>
> -#include <ccan/array_size/array_size.h>
>  
>  #include <util/strbuf.h>
>  #include <util/util.h>
> diff --git a/tools/ndctl/daxctl/lib/libdaxctl-private.h b/tools/ndctl/daxctl/lib/libdaxctl-private.h
> index f7667324026f..62b0bc1e8dc5 100644
> --- a/tools/ndctl/daxctl/lib/libdaxctl-private.h
> +++ b/tools/ndctl/daxctl/lib/libdaxctl-private.h
> @@ -31,7 +31,7 @@ struct daxctl_region {
>  	unsigned long align;
>  	unsigned long long size;
>  	struct daxctl_ctx *ctx;
> -	struct list_node list;
> +	struct list_head list;
>  	struct list_head devices;
>  };
>  
> @@ -40,7 +40,7 @@ struct daxctl_dev {
>  	void *dev_buf;
>  	size_t buf_len;
>  	char *dev_path;
> -	struct list_node list;
> +	struct list_head list;
>  	unsigned long long size;
>  	struct daxctl_region *region;
>  };
> diff --git a/tools/ndctl/daxctl/lib/libdaxctl.c b/tools/ndctl/daxctl/lib/libdaxctl.c
> index 89f8cc8e69ff..61877cdd4d43 100644
> --- a/tools/ndctl/daxctl/lib/libdaxctl.c
> +++ b/tools/ndctl/daxctl/lib/libdaxctl.c
> @@ -19,11 +19,11 @@
>  #include <sys/types.h>
>  #include <sys/sysmacros.h>
>  #include <uuid/uuid.h>
> -#include <ccan/list/list.h>
> -#include <ccan/array_size/array_size.h>
>  
>  #include <util/log.h>
> +#include <util/list.h>
>  #include <util/sysfs.h>
> +#include <util/kernel.h>
>  #include <daxctl/libdaxctl.h>
>  #include "libdaxctl-private.h"
>  
> @@ -93,7 +93,7 @@ DAXCTL_EXPORT int daxctl_new(struct daxctl_ctx **ctx)
>  	info(c, "ctx %p created\n", c);
>  	dbg(c, "log_priority=%d\n", c->ctx.log_priority);
>  	*ctx = c;
> -	list_head_init(&c->regions);
> +	INIT_LIST_HEAD(&c->regions);
>  
>  	return 0;
>  }
> @@ -190,7 +190,7 @@ static void free_region(struct daxctl_region *region, struct list_head *head)
>  {
>  	struct daxctl_dev *dev, *_d;
>  
> -	list_for_each_safe(&region->devices, dev, _d, list)
> +	list_for_each_entry_safe(dev, _d, &region->devices, list)
>  		free_dev(dev, &region->devices);
>  	if (head)
>  		list_del_from(head, &region->list);
> @@ -248,7 +248,7 @@ static struct daxctl_region *add_dax_region(void *parent, int id,
>  	region->size = -1;
>  	region->ctx = ctx;
>  	region->refcount = 1;
> -	list_head_init(&region->devices);
> +	INIT_LIST_HEAD(&region->devices);
>  	region->devname = strdup(devpath_to_devname(base));
>  
>  	sprintf(path, "%s/%s/size", base, attrs);
> @@ -269,7 +269,7 @@ static struct daxctl_region *add_dax_region(void *parent, int id,
>  		goto err_read;
>  	region->buf_len = strlen(path) + REGION_BUF_SIZE;
>  
> -	list_add(&ctx->regions, &region->list);
> +	list_add(&region->list, &ctx->regions);
>  
>  	free(path);
>  	return region;
> @@ -345,7 +345,7 @@ static void *add_dax_dev(void *parent, int id, const char *daxdev_base)
>  			return dev_dup;
>  		}
>  
> -	list_add(&region->devices, &dev->list);
> +	list_add(&dev->list, &region->devices);
>  	free(path);
>  	return dev;
>  
> @@ -525,7 +525,8 @@ DAXCTL_EXPORT struct daxctl_dev *daxctl_dev_get_first(struct daxctl_region *regi
>  {
>  	dax_devices_init(region);
>  
> -	return list_top(&region->devices, struct daxctl_dev, list);
> +	return list_first_entry_or_null(&region->devices, struct daxctl_dev,
> +			list);
>  }
>  
>  DAXCTL_EXPORT struct daxctl_dev *daxctl_dev_get_next(struct daxctl_dev *dev)
> @@ -540,7 +541,8 @@ DAXCTL_EXPORT struct daxctl_region *daxctl_region_get_first(
>  {
>  	dax_regions_init(ctx);
>  
> -	return list_top(&ctx->regions, struct daxctl_region, list);
> +	return list_first_entry_or_null(&ctx->regions, struct daxctl_region,
> +			list);
>  }
>  
>  DAXCTL_EXPORT struct daxctl_region *daxctl_region_get_next(
> diff --git a/tools/ndctl/daxctl/list.c b/tools/ndctl/daxctl/list.c
> index 254f0ac9be79..95fcaa2eb79c 100644
> --- a/tools/ndctl/daxctl/list.c
> +++ b/tools/ndctl/daxctl/list.c
> @@ -17,10 +17,10 @@
>  #include <limits.h>
>  #include <util/json.h>
>  #include <util/filter.h>
> +#include <util/kernel.h>
>  #include <json-c/json.h>
>  #include <daxctl/libdaxctl.h>
>  #include <util/parse-options.h>
> -#include <ccan/array_size/array_size.h>
>  
>  static struct {
>  	bool devs;
> diff --git a/tools/ndctl/ndctl/check.c b/tools/ndctl/ndctl/check.c
> index e05d1b073653..71a560eeda81 100644
> --- a/tools/ndctl/ndctl/check.c
> +++ b/tools/ndctl/ndctl/check.c
> @@ -27,15 +27,15 @@
>  #include <util/json.h>
>  #include <util/size.h>
>  #include <util/util.h>
> -#include <util/bitmap.h>
> +#include <util/kernel.h>
>  #include <util/fletcher.h>
>  #include <ndctl/libndctl.h>
> -#include <ccan/endian/endian.h>
> -#include <ccan/minmax/minmax.h>
> -#include <ccan/array_size/array_size.h>
>  #include <ccan/short_types/short_types.h>
>  #include "check.h"
>  
> +#include <ccan/endian/endian.h>
> +#include <linux/bitmap.h>
> +
>  #ifdef HAVE_NDCTL_H
>  #include <linux/ndctl.h>
>  #else
> @@ -143,7 +143,7 @@ static int btt_copy_to_info2(struct arena_info *a)
>  	memcpy(a->map.info2, a->map.info, BTT_INFO_SIZE);
>  
>  	ms_align = (void *)rounddown((u64)a->map.info2, a->bttc->sys_page_size);
> -	ms_size = max(BTT_INFO_SIZE, a->bttc->sys_page_size);
> +	ms_size = max((long) BTT_INFO_SIZE, a->bttc->sys_page_size);
>  	if (msync(ms_align, ms_size, MS_SYNC) < 0)
>  		return errno;
>  
> @@ -250,7 +250,7 @@ static int btt_checksum_verify(struct btt_sb *btt_sb)
>  	uint64_t sum;
>  	le64 sum_save;
>  
> -	BUILD_BUG_ON(sizeof(struct btt_sb) != SZ_4K);
> +	(void) BUILD_BUG_ON_ZERO(sizeof(struct btt_sb) != SZ_4K);
>  
>  	sum_save = btt_sb->checksum;
>  	btt_sb->checksum = 0;
> @@ -482,7 +482,7 @@ static int btt_check_bitmap(struct arena_info *a)
>  			rc = BTT_BITMAP_ERROR;
>  			goto out;
>  		}
> -		bitmap_set(bm, btt_mapping, 1);
> +		set_bit(btt_mapping, bm);
>  	}
>  
>  	/* map 'nfree' number of flog entries */
> @@ -499,7 +499,7 @@ static int btt_check_bitmap(struct arena_info *a)
>  			rc = BTT_BITMAP_ERROR;
>  			goto out;
>  		}
> -		bitmap_set(bm, log.old_map, 1);
> +		set_bit(log.old_map, bm);
>  	}
>  
>  	/* check that the bitmap is full */
> diff --git a/tools/ndctl/ndctl/create-nfit.c b/tools/ndctl/ndctl/create-nfit.c
> index 6adfae7af014..fec3adfb5c70 100644
> --- a/tools/ndctl/ndctl/create-nfit.c
> +++ b/tools/ndctl/ndctl/create-nfit.c
> @@ -14,11 +14,12 @@
>  #include <errno.h>
>  #include <stdlib.h>
>  #include <fcntl.h>
> +#include <limits.h>
>  #include <unistd.h>
>  #include <endian.h>
>  #include <sys/types.h>
>  #include <sys/stat.h>
> -#include <ccan/list/list.h>
> +#include <util/list.h>
>  #include <util/parse-options.h>
>  #include <util/size.h>
>  
> @@ -29,7 +30,7 @@ static const char *nfit_file = DEFAULT_NFIT;
>  static LIST_HEAD(spas);
>  
>  struct spa {
> -	struct list_node list;
> +	struct list_head list;
>  	unsigned long long size, offset;
>  };
>  
> @@ -56,7 +57,7 @@ static int parse_add_spa(const struct option *option, const char *__arg, int uns
>  	if (s->offset == ULLONG_MAX)
>  		goto err;
>  
> -	list_add_tail(&spas, &s->list);
> +	list_add_tail(&s->list, &spas);
>  	free(arg);
>  
>  	return 0;
> @@ -116,7 +117,7 @@ static struct nfit *create_nfit(struct list_head *spa_list)
>  	int i;
>  
>  	size = sizeof(struct nfit);
> -	list_for_each(spa_list, s, list)
> +	list_for_each_entry(s, spa_list, list)
>  		size += sizeof(struct nfit_spa);
>  
>  	buf = calloc(1, size);
> @@ -136,7 +137,7 @@ static struct nfit *create_nfit(struct list_head *spa_list)
>  
>  	nfit_spa = (struct nfit_spa *) (buf + sizeof(*nfit));
>  	i = 1;
> -	list_for_each(spa_list, s, list) {
> +	list_for_each_entry(s, spa_list, list) {
>  		writew(NFIT_TABLE_SPA, &nfit_spa->type);
>  		writew(sizeof(*nfit_spa), &nfit_spa->length);
>  		nfit_spa_uuid_pm(&nfit_spa->type_uuid);
> @@ -218,7 +219,7 @@ int cmd_create_nfit(int argc, const char **argv, void *ctx)
>  
>   out:
>  	free(nfit);
> -	list_for_each_safe(&spas, s, _s, list) {
> +	list_for_each_entry_safe(s, _s, &spas, list) {
>  		list_del(&s->list);
>  		free(s);
>  	}
> diff --git a/tools/ndctl/ndctl/dimm.c b/tools/ndctl/ndctl/dimm.c
> index 264917d05cc0..91bf7c53c3db 100644
> --- a/tools/ndctl/ndctl/dimm.c
> +++ b/tools/ndctl/ndctl/dimm.c
> @@ -22,13 +22,15 @@
>  #include <util/json.h>
>  #include <util/filter.h>
>  #include <json-c/json.h>
> +#include <util/kernel.h>
>  #include <util/fletcher.h>
>  #include <ndctl/libndctl.h>
>  #include <util/parse-options.h>
> -#include <ccan/minmax/minmax.h>
>  #include <ccan/short_types/short_types.h>
> +
>  #include <ccan/endian/endian.h>
> -#include <ccan/array_size/array_size.h>
> +#define cpu_to_le64 cpu_to_le64
> +#include <linux/bitmap.h>
>  
>  enum {
>  	NSINDEX_SIG_LEN = 16,
> @@ -176,7 +178,7 @@ static struct json_object *dump_label_json(struct ndctl_cmd *cmd_read, ssize_t s
>  
>  	for (offset = NSINDEX_ALIGN * 2; offset < size;
>  			offset += sizeof_namespace_label(ndd)) {
> -		ssize_t len = min_t(ssize_t, sizeof_namespace_label(ndd),
> +		ssize_t len = min((ssize_t) sizeof_namespace_label(ndd),
>  				size - offset);
>  		struct json_object *jobj;
>  		char uuid[40];
> @@ -282,7 +284,7 @@ static struct json_object *dump_index_json(struct ndctl_cmd *cmd_read, ssize_t s
>  		return NULL;
>  
>  	for (offset = 0; offset < NSINDEX_ALIGN * 2; offset += NSINDEX_ALIGN) {
> -		ssize_t len = min_t(ssize_t, sizeof(nsindex), size - offset);
> +		ssize_t len = min((ssize_t) sizeof(nsindex), size - offset);
>  		struct json_object *jobj;
>  
>  		jindex = json_object_new_object();
> @@ -379,7 +381,7 @@ static int rw_bin(FILE *f, struct ndctl_cmd *cmd, ssize_t size, int rw)
>  	ssize_t offset, write = 0;
>  
>  	for (offset = 0; offset < size; offset += sizeof(buf)) {
> -		ssize_t len = min_t(ssize_t, sizeof(buf), size - offset), rc;
> +		ssize_t len = min((ssize_t) sizeof(buf), size - offset), rc;
>  
>  		if (rw) {
>  			len = fread(buf, 1, len, f);
> diff --git a/tools/ndctl/ndctl/lib/libndctl-private.h b/tools/ndctl/ndctl/lib/libndctl-private.h
> index 8f10fbc76aca..63e50115012c 100644
> --- a/tools/ndctl/ndctl/lib/libndctl-private.h
> +++ b/tools/ndctl/ndctl/lib/libndctl-private.h
> @@ -21,15 +21,15 @@
>  #include <libkmod.h>
>  #include <util/log.h>
>  #include <uuid/uuid.h>
> -#include <ccan/list/list.h>
> -#include <ccan/array_size/array_size.h>
> +#include <util/kernel.h>
> +#include <util/list.h>
> +#include <ccan/endian/endian.h>
>  #ifdef HAVE_NDCTL_H
>  #include <linux/ndctl.h>
>  #else
>  #include <ndctl.h>
>  #endif
>  #include <ndctl/libndctl.h>
> -#include <ccan/endian/endian.h>
>  #include <ccan/short_types/short_types.h>
>  #include "ndctl-hpe1.h"
>  #include "ndctl-msft.h"
> diff --git a/tools/ndctl/ndctl/lib/libndctl-smart.c b/tools/ndctl/ndctl/lib/libndctl-smart.c
> index 73a49efe5d58..bc2b4a95da19 100644
> --- a/tools/ndctl/ndctl/lib/libndctl-smart.c
> +++ b/tools/ndctl/ndctl/lib/libndctl-smart.c
> @@ -13,6 +13,7 @@
>  #include <stdlib.h>
>  #include <limits.h>
>  #include <util/log.h>
> +#include <util/kernel.h>
>  #include <ndctl/libndctl.h>
>  #include "libndctl-private.h"
>  
> @@ -76,7 +77,7 @@ static struct ndctl_cmd *intel_dimm_cmd_new_smart(struct ndctl_dimm *dimm)
>  	struct ndctl_cmd *cmd;
>  	size_t size;
>  
> -	BUILD_ASSERT(sizeof(struct nd_smart_payload) == 128);
> +	(void) BUILD_BUG_ON_ZERO(sizeof(struct nd_smart_payload) != 128);
>  
>  	if (!ndctl_dimm_is_cmd_supported(dimm, ND_CMD_SMART)) {
>  		dbg(ctx, "unsupported cmd\n");
> @@ -165,7 +166,7 @@ static struct ndctl_cmd *intel_dimm_cmd_new_smart_threshold(
>  	struct ndctl_cmd *cmd;
>  	size_t size;
>  
> -	BUILD_ASSERT(sizeof(struct nd_smart_threshold_payload) == 8);
> +	(void) BUILD_BUG_ON_ZERO(sizeof(struct nd_smart_threshold_payload) != 8);
>  
>  	if (!ndctl_dimm_is_cmd_supported(dimm, ND_CMD_SMART_THRESHOLD)) {
>  		dbg(ctx, "unsupported cmd\n");
> diff --git a/tools/ndctl/ndctl/lib/libndctl.c b/tools/ndctl/ndctl/lib/libndctl.c
> index 68d806444589..c3ef61ca6a0a 100644
> --- a/tools/ndctl/ndctl/lib/libndctl.c
> +++ b/tools/ndctl/ndctl/lib/libndctl.c
> @@ -14,6 +14,7 @@
>  #include <stdlib.h>
>  #include <stddef.h>
>  #include <stdarg.h>
> +#include <limits.h>
>  #include <unistd.h>
>  #include <errno.h>
>  #include <string.h>
> @@ -23,10 +24,8 @@
>  #include <sys/stat.h>
>  #include <sys/types.h>
>  #include <sys/ioctl.h>
> -#include <ccan/list/list.h>
> -#include <ccan/minmax/minmax.h>
> -#include <ccan/array_size/array_size.h>
> -#include <ccan/build_assert/build_assert.h>
> +#include <util/sysfs.h>
> +#include <util/kernel.h>
>  
>  #ifdef HAVE_NDCTL_H
>  #include <linux/ndctl.h>
> @@ -34,7 +33,6 @@
>  #include <ndctl.h>
>  #endif
>  
> -#include <util/sysfs.h>
>  #include <ndctl/libndctl.h>
>  #include <daxctl/libdaxctl.h>
>  #include "libndctl-private.h"
> @@ -93,7 +91,7 @@ struct ndctl_bus {
>  	char *provider;
>  	struct list_head dimms;
>  	struct list_head regions;
> -	struct list_node list;
> +	struct list_head list;
>  	int dimms_init;
>  	int regions_init;
>  	int has_nfit;
> @@ -156,7 +154,7 @@ struct ndctl_dimm {
>  			unsigned int f_notify:1;
>  		};
>  	} flags;
> -	struct list_node list;
> +	struct list_head list;
>  	int formats;
>  	int format[0];
>  };
> @@ -174,7 +172,7 @@ struct ndctl_mapping {
>  	struct ndctl_region *region;
>  	struct ndctl_dimm *dimm;
>  	unsigned long long offset, length;
> -	struct list_node list;
> +	struct list_head list;
>  };
>  
>  /**
> @@ -219,7 +217,7 @@ struct ndctl_region {
>  	struct list_head stale_btts;
>  	struct list_head stale_pfns;
>  	struct list_head stale_daxs;
> -	struct list_node list;
> +	struct list_head list;
>  	/**
>  	 * struct ndctl_interleave_set - extra info for interleave sets
>  	 * @state: are any interleave set members active or all idle
> @@ -261,7 +259,7 @@ struct ndctl_lbasize {
>  struct ndctl_namespace {
>  	struct kmod_module *module;
>  	struct ndctl_region *region;
> -	struct list_node list;
> +	struct list_head list;
>  	char *ndns_path;
>  	char *ndns_buf;
>  	char *bdev;
> @@ -291,7 +289,7 @@ struct ndctl_btt {
>  	struct kmod_module *module;
>  	struct ndctl_region *region;
>  	struct ndctl_namespace *ndns;
> -	struct list_node list;
> +	struct list_head list;
>  	struct ndctl_lbasize lbasize;
>  	unsigned long long size;
>  	char *btt_path;
> @@ -318,7 +316,7 @@ struct ndctl_pfn {
>  	struct kmod_module *module;
>  	struct ndctl_region *region;
>  	struct ndctl_namespace *ndns;
> -	struct list_node list;
> +	struct list_head list;
>  	enum ndctl_pfn_loc loc;
>  	unsigned long align;
>  	unsigned long long resource, size;
> @@ -402,7 +400,7 @@ NDCTL_EXPORT int ndctl_new(struct ndctl_ctx **ctx)
>  	log_init(&c->ctx, "libndctl", "NDCTL_LOG");
>  	c->udev = udev;
>  	c->timeout = 5000;
> -	list_head_init(&c->busses);
> +	INIT_LIST_HEAD(&c->busses);
>  
>  	info(c, "ctx %p created\n", c);
>  	dbg(c, "log_priority=%d\n", c->ctx.log_priority);
> @@ -483,7 +481,7 @@ static void free_namespaces(struct ndctl_region *region)
>  {
>  	struct ndctl_namespace *ndns, *_n;
>  
> -	list_for_each_safe(&region->namespaces, ndns, _n, list)
> +	list_for_each_entry_safe(ndns, _n, &region->namespaces, list)
>  		free_namespace(ndns, &region->namespaces);
>  }
>  
> @@ -491,7 +489,7 @@ static void free_stale_namespaces(struct ndctl_region *region)
>  {
>  	struct ndctl_namespace *ndns, *_n;
>  
> -	list_for_each_safe(&region->stale_namespaces, ndns, _n, list)
> +	list_for_each_entry_safe(ndns, _n, &region->stale_namespaces, list)
>  		free_namespace(ndns, &region->stale_namespaces);
>  }
>  
> @@ -511,7 +509,7 @@ static void free_btts(struct ndctl_region *region)
>  {
>  	struct ndctl_btt *btt, *_b;
>  
> -	list_for_each_safe(&region->btts, btt, _b, list)
> +	list_for_each_entry_safe(btt, _b, &region->btts, list)
>  		free_btt(btt, &region->btts);
>  }
>  
> @@ -519,7 +517,7 @@ static void free_stale_btts(struct ndctl_region *region)
>  {
>  	struct ndctl_btt *btt, *_b;
>  
> -	list_for_each_safe(&region->stale_btts, btt, _b, list)
> +	list_for_each_entry_safe(btt, _b, &region->stale_btts, list)
>  		free_btt(btt, &region->stale_btts);
>  }
>  
> @@ -548,7 +546,7 @@ static void free_pfns(struct ndctl_region *region)
>  {
>  	struct ndctl_pfn *pfn, *_b;
>  
> -	list_for_each_safe(&region->pfns, pfn, _b, list)
> +	list_for_each_entry_safe(pfn, _b, &region->pfns, list)
>  		free_pfn(pfn, &region->pfns);
>  }
>  
> @@ -556,7 +554,7 @@ static void free_daxs(struct ndctl_region *region)
>  {
>  	struct ndctl_dax *dax, *_b;
>  
> -	list_for_each_safe(&region->daxs, dax, _b, pfn.list)
> +	list_for_each_entry_safe(dax, _b, &region->daxs, pfn.list)
>  		free_dax(dax, &region->daxs);
>  }
>  
> @@ -564,7 +562,7 @@ static void free_stale_pfns(struct ndctl_region *region)
>  {
>  	struct ndctl_pfn *pfn, *_b;
>  
> -	list_for_each_safe(&region->stale_pfns, pfn, _b, list)
> +	list_for_each_entry_safe(pfn, _b, &region->stale_pfns, list)
>  		free_pfn(pfn, &region->stale_pfns);
>  }
>  
> @@ -572,7 +570,7 @@ static void free_stale_daxs(struct ndctl_region *region)
>  {
>  	struct ndctl_dax *dax, *_b;
>  
> -	list_for_each_safe(&region->stale_daxs, dax, _b, pfn.list)
> +	list_for_each_entry_safe(dax, _b, &region->stale_daxs, pfn.list)
>  		free_dax(dax, &region->stale_daxs);
>  }
>  
> @@ -581,7 +579,7 @@ static void free_region(struct ndctl_region *region)
>  	struct ndctl_bus *bus = region->bus;
>  	struct ndctl_mapping *mapping, *_m;
>  
> -	list_for_each_safe(&region->mappings, mapping, _m, list) {
> +	list_for_each_entry_safe(mapping, _m, &region->mappings, list) {
>  		list_del_from(&region->mappings, &mapping->list);
>  		free(mapping);
>  	}
> @@ -621,11 +619,11 @@ static void free_bus(struct ndctl_bus *bus, struct list_head *head)
>  	struct ndctl_dimm *dimm, *_d;
>  	struct ndctl_region *region, *_r;
>  
> -	list_for_each_safe(&bus->dimms, dimm, _d, list) {
> +	list_for_each_entry_safe(dimm, _d, &bus->dimms, list) {
>  		list_del_from(&bus->dimms, &dimm->list);
>  		free_dimm(dimm);
>  	}
> -	list_for_each_safe(&bus->regions, region, _r, list)
> +	list_for_each_entry_safe(region, _r, &bus->regions, list)
>  		free_region(region);
>  	if (head)
>  		list_del_from(head, &bus->list);
> @@ -640,7 +638,7 @@ static void free_context(struct ndctl_ctx *ctx)
>  {
>  	struct ndctl_bus *bus, *_b;
>  
> -	list_for_each_safe(&ctx->busses, bus, _b, list)
> +	list_for_each_entry_safe(bus, _b, &ctx->busses, list)
>  		free_bus(bus, &ctx->busses);
>  	free(ctx);
>  }
> @@ -820,8 +818,8 @@ static void *add_bus(void *parent, int id, const char *ctl_base)
>  	bus = calloc(1, sizeof(*bus));
>  	if (!bus)
>  		goto err_bus;
> -	list_head_init(&bus->dimms);
> -	list_head_init(&bus->regions);
> +	INIT_LIST_HEAD(&bus->dimms);
> +	INIT_LIST_HEAD(&bus->regions);
>  	bus->ctx = ctx;
>  	bus->id = id;
>  
> @@ -874,7 +872,7 @@ static void *add_bus(void *parent, int id, const char *ctl_base)
>  			return bus_dup;
>  		}
>  
> -	list_add(&ctx->busses, &bus->list);
> +	list_add(&bus->list, &ctx->busses);
>  	free(path);
>  
>  	return bus;
> @@ -916,7 +914,7 @@ NDCTL_EXPORT struct ndctl_bus *ndctl_bus_get_first(struct ndctl_ctx *ctx)
>  {
>  	busses_init(ctx);
>  
> -	return list_top(&ctx->busses, struct ndctl_bus, list);
> +	return list_first_entry_or_null(&ctx->busses, struct ndctl_bus, list);
>  }
>  
>  /**
> @@ -1307,7 +1305,7 @@ static void *add_dimm(void *parent, int id, const char *dimm_base)
>  
>  	dimm->health_eventfd = open(path, O_RDONLY|O_CLOEXEC);
>   out:
> -	list_add(&bus->dimms, &dimm->list);
> +	list_add(&dimm->list, &bus->dimms);
>  	free(path);
>  
>  	return dimm;
> @@ -1332,7 +1330,7 @@ NDCTL_EXPORT struct ndctl_dimm *ndctl_dimm_get_first(struct ndctl_bus *bus)
>  {
>  	dimms_init(bus);
>  
> -	return list_top(&bus->dimms, struct ndctl_dimm, list);
> +	return list_first_entry_or_null(&bus->dimms, struct ndctl_dimm, list);
>  }
>  
>  NDCTL_EXPORT struct ndctl_dimm *ndctl_dimm_get_next(struct ndctl_dimm *dimm)
> @@ -1618,15 +1616,15 @@ static void *add_region(void *parent, int id, const char *region_base)
>  	region = calloc(1, sizeof(*region));
>  	if (!region)
>  		goto err_region;
> -	list_head_init(&region->btts);
> -	list_head_init(&region->pfns);
> -	list_head_init(&region->daxs);
> -	list_head_init(&region->stale_btts);
> -	list_head_init(&region->stale_pfns);
> -	list_head_init(&region->stale_daxs);
> -	list_head_init(&region->mappings);
> -	list_head_init(&region->namespaces);
> -	list_head_init(&region->stale_namespaces);
> +	INIT_LIST_HEAD(&region->btts);
> +	INIT_LIST_HEAD(&region->pfns);
> +	INIT_LIST_HEAD(&region->daxs);
> +	INIT_LIST_HEAD(&region->stale_btts);
> +	INIT_LIST_HEAD(&region->stale_pfns);
> +	INIT_LIST_HEAD(&region->stale_daxs);
> +	INIT_LIST_HEAD(&region->mappings);
> +	INIT_LIST_HEAD(&region->namespaces);
> +	INIT_LIST_HEAD(&region->stale_namespaces);
>  	region->bus = bus;
>  	region->id = id;
>  
> @@ -1681,7 +1679,7 @@ static void *add_region(void *parent, int id, const char *region_base)
>  	if (!region->region_path)
>  		goto err_read;
>  
> -	list_add(&bus->regions, &region->list);
> +	list_add(&region->list, &bus->regions);
>  
>  	free(path);
>  	return region;
> @@ -1708,7 +1706,8 @@ NDCTL_EXPORT struct ndctl_region *ndctl_region_get_first(struct ndctl_bus *bus)
>  {
>  	regions_init(bus);
>  
> -	return list_top(&bus->regions, struct ndctl_region, list);
> +	return list_first_entry_or_null(&bus->regions, struct ndctl_region,
> +			list);
>  }
>  
>  NDCTL_EXPORT struct ndctl_region *ndctl_region_get_next(struct ndctl_region *region)
> @@ -2018,7 +2017,7 @@ NDCTL_EXPORT ssize_t ndctl_cmd_vendor_get_output(struct ndctl_cmd *cmd,
>  	if (out_length < 0)
>  		return out_length;
>  
> -	len = min(len, out_length);
> +	len = min((ssize_t) len, out_length);
>  	memcpy(buf, to_vendor_tail(cmd)->out_buf, len);
>  	return len;
>  }
> @@ -2533,10 +2532,10 @@ static int ndctl_region_disable(struct ndctl_region *region, int cleanup)
>  	region->btts_init = 0;
>  	region->pfns_init = 0;
>  	region->daxs_init = 0;
> -	list_append_list(&region->stale_namespaces, &region->namespaces);
> -	list_append_list(&region->stale_btts, &region->btts);
> -	list_append_list(&region->stale_pfns, &region->pfns);
> -	list_append_list(&region->stale_daxs, &region->daxs);
> +	list_splice_init(&region->namespaces, &region->stale_namespaces);
> +	list_splice_init(&region->btts, &region->stale_btts);
> +	list_splice_init(&region->pfns, &region->stale_pfns);
> +	list_splice_init(&region->daxs, &region->stale_daxs);
>  	region->generation++;
>  	if (cleanup)
>  		ndctl_region_cleanup(region);
> @@ -2755,7 +2754,7 @@ static void mappings_init(struct ndctl_region *region)
>  		mapping->offset = offset;
>  		mapping->length = length;
>  		mapping->dimm = dimm;
> -		list_add(&region->mappings, &mapping->list);
> +		list_add(&mapping->list, &region->mappings);
>  	}
>  	free(mapping_path);
>  }
> @@ -2764,7 +2763,8 @@ NDCTL_EXPORT struct ndctl_mapping *ndctl_mapping_get_first(struct ndctl_region *
>  {
>  	mappings_init(region);
>  
> -	return list_top(&region->mappings, struct ndctl_mapping, list);
> +	return list_first_entry_or_null(&region->mappings,
> +			struct ndctl_mapping, list);
>  }
>  
>  NDCTL_EXPORT struct ndctl_mapping *ndctl_mapping_get_next(struct ndctl_mapping *mapping)
> @@ -2991,7 +2991,7 @@ static void *add_namespace(void *parent, int id, const char *ndns_base)
>  			return ndns_dup;
>  		}
>  
> -	list_add(&region->namespaces, &ndns->list);
> +	list_add(&ndns->list, &region->namespaces);
>  	free(path);
>  	return ndns;
>  
> @@ -3023,7 +3023,8 @@ NDCTL_EXPORT struct ndctl_namespace *ndctl_namespace_get_first(struct ndctl_regi
>  {
>  	namespaces_init(region);
>  
> -	return list_top(&region->namespaces, struct ndctl_namespace, list);
> +	return list_first_entry_or_null(&region->namespaces,
> +			struct ndctl_namespace, list);
>  }
>  
>  NDCTL_EXPORT struct ndctl_namespace *ndctl_namespace_get_next(struct ndctl_namespace *ndns)
> @@ -3915,7 +3916,7 @@ static void *add_btt(void *parent, int id, const char *btt_base)
>  			return btt_dup;
>  		}
>  
> -	list_add(&region->btts, &btt->list);
> +	list_add(&btt->list, &region->btts);
>  	return btt;
>  
>   err_read:
> @@ -3932,7 +3933,7 @@ NDCTL_EXPORT struct ndctl_btt *ndctl_btt_get_first(struct ndctl_region *region)
>  {
>  	btts_init(region);
>  
> -	return list_top(&region->btts, struct ndctl_btt, list);
> +	return list_first_entry_or_null(&region->btts, struct ndctl_btt, list);
>  }
>  
>  NDCTL_EXPORT struct ndctl_btt *ndctl_btt_get_next(struct ndctl_btt *btt)
> @@ -4305,7 +4306,7 @@ static void *add_pfn(void *parent, int id, const char *pfn_base)
>  			return pfn_dup;
>  		}
>  
> -	list_add(&region->pfns, &pfn->list);
> +	list_add(&pfn->list, &region->pfns);
>  
>  	return pfn;
>  }
> @@ -4337,7 +4338,7 @@ static void *add_dax(void *parent, int id, const char *dax_base)
>  		}
>  	}
>  
> -	list_add(&region->daxs, &dax->pfn.list);
> +	list_add(&dax->pfn.list, &region->daxs);
>  
>  	return dax;
>  }
> @@ -4346,7 +4347,7 @@ NDCTL_EXPORT struct ndctl_pfn *ndctl_pfn_get_first(struct ndctl_region *region)
>  {
>  	pfns_init(region);
>  
> -	return list_top(&region->pfns, struct ndctl_pfn, list);
> +	return list_first_entry_or_null(&region->pfns, struct ndctl_pfn, list);
>  }
>  
>  NDCTL_EXPORT struct ndctl_pfn *ndctl_pfn_get_next(struct ndctl_pfn *pfn)
> @@ -4668,7 +4669,8 @@ NDCTL_EXPORT struct ndctl_dax *ndctl_dax_get_first(struct ndctl_region *region)
>  {
>  	daxs_init(region);
>  
> -	return list_top(&region->daxs, struct ndctl_dax, pfn.list);
> +	return list_first_entry_or_null(&region->daxs, struct ndctl_dax,
> +			pfn.list);
>  }
>  
>  NDCTL_EXPORT struct ndctl_dax *ndctl_dax_get_next(struct ndctl_dax *dax)
> diff --git a/tools/ndctl/ndctl/list.c b/tools/ndctl/ndctl/list.c
> index c910c776c61d..a4f9ef4a5eff 100644
> --- a/tools/ndctl/ndctl/list.c
> +++ b/tools/ndctl/ndctl/list.c
> @@ -16,11 +16,11 @@
>  #include <unistd.h>
>  #include <limits.h>
>  #include <util/json.h>
> +#include <util/kernel.h>
>  #include <util/filter.h>
>  #include <json-c/json.h>
>  #include <ndctl/libndctl.h>
>  #include <util/parse-options.h>
> -#include <ccan/array_size/array_size.h>
>  
>  #ifdef HAVE_NDCTL_H
>  #include <linux/ndctl.h>
> diff --git a/tools/ndctl/ndctl/namespace.c b/tools/ndctl/ndctl/namespace.c
> index 4734ebdb22b0..86f4405ec9e1 100644
> --- a/tools/ndctl/ndctl/namespace.c
> +++ b/tools/ndctl/ndctl/namespace.c
> @@ -23,11 +23,10 @@
>  #include <util/size.h>
>  #include <util/json.h>
>  #include <json-c/json.h>
> +#include <util/kernel.h>
>  #include <util/filter.h>
>  #include <ndctl/libndctl.h>
>  #include <util/parse-options.h>
> -#include <ccan/minmax/minmax.h>
> -#include <ccan/array_size/array_size.h>
>  #include "check.h"
>  
>  #ifdef HAVE_NDCTL_H
> diff --git a/tools/ndctl/ndctl/ndctl.c b/tools/ndctl/ndctl/ndctl.c
> index d10718e5d9c7..c87752eccc8a 100644
> --- a/tools/ndctl/ndctl/ndctl.c
> +++ b/tools/ndctl/ndctl/ndctl.c
> @@ -23,9 +23,9 @@
>  #include <sys/types.h>
>  #include <builtin.h>
>  #include <ndctl/libndctl.h>
> -#include <ccan/array_size/array_size.h>
>  
>  #include <util/parse-options.h>
> +#include <util/kernel.h>
>  #include <util/strbuf.h>
>  #include <util/util.h>
>  #include <util/main.h>
> diff --git a/tools/ndctl/ndctl/util/json-smart.c b/tools/ndctl/ndctl/util/json-smart.c
> index aaaa0de6a72b..04a6fe4572cf 100644
> --- a/tools/ndctl/ndctl/util/json-smart.c
> +++ b/tools/ndctl/ndctl/util/json-smart.c
> @@ -14,8 +14,8 @@
>  #include <util/json.h>
>  #include <uuid/uuid.h>
>  #include <json-c/json.h>
> +#include <util/kernel.h>
>  #include <ndctl/libndctl.h>
> -#include <ccan/array_size/array_size.h>
>  
>  #ifdef HAVE_NDCTL_H
>  #include <linux/ndctl.h>
> diff --git a/tools/ndctl/test/blk_namespaces.c b/tools/ndctl/test/blk_namespaces.c
> index 178f73cacb16..2f1fe7a99aa3 100644
> --- a/tools/ndctl/test/blk_namespaces.c
> +++ b/tools/ndctl/test/blk_namespaces.c
> @@ -20,6 +20,7 @@
>  #include <stdlib.h>
>  #include <string.h>
>  #include <sys/ioctl.h>
> +#include <util/kernel.h>
>  #include <syslog.h>
>  #include <sys/stat.h>
>  #include <sys/types.h>
> @@ -28,7 +29,6 @@
>  #include <linux/version.h>
>  #include <test.h>
>  #include <libkmod.h>
> -#include <ccan/array_size/array_size.h>
>  
>  #ifdef HAVE_NDCTL_H
>  #include <linux/ndctl.h>
> diff --git a/tools/ndctl/test/core.c b/tools/ndctl/test/core.c
> index e0806ed24058..e5b24c9d8a2e 100644
> --- a/tools/ndctl/test/core.c
> +++ b/tools/ndctl/test/core.c
> @@ -20,7 +20,7 @@
>  
>  #include <util/log.h>
>  #include <util/sysfs.h>
> -#include <ccan/array_size/array_size.h>
> +#include <util/kernel.h>
>  
>  #define KVER_STRLEN 20
>  
> diff --git a/tools/ndctl/test/daxdev-errors.c b/tools/ndctl/test/daxdev-errors.c
> index ba89b0c047a7..991a7cbff516 100644
> --- a/tools/ndctl/test/daxdev-errors.c
> +++ b/tools/ndctl/test/daxdev-errors.c
> @@ -30,7 +30,7 @@
>  
>  #include <util/log.h>
>  #include <util/sysfs.h>
> -#include <ccan/array_size/array_size.h>
> +#include <util/kernel.h>
>  #include <ndctl/libndctl.h>
>  #include <daxctl/libdaxctl.h>
>  #ifdef HAVE_NDCTL_H
> diff --git a/tools/ndctl/test/device-dax.c b/tools/ndctl/test/device-dax.c
> index d9196a760cea..d3a07aae3e9a 100644
> --- a/tools/ndctl/test/device-dax.c
> +++ b/tools/ndctl/test/device-dax.c
> @@ -24,11 +24,11 @@
>  #include <sys/time.h>
>  #include <sys/types.h>
>  #include <util/size.h>
> +#include <util/kernel.h>
>  #include <linux/falloc.h>
>  #include <linux/version.h>
>  #include <ndctl/libndctl.h>
>  #include <daxctl/libdaxctl.h>
> -#include <ccan/array_size/array_size.h>
>  
>  #include <builtin.h>
>  #include <test.h>
> diff --git a/tools/ndctl/test/dpa-alloc.c b/tools/ndctl/test/dpa-alloc.c
> index d13cf5dde66f..e708a9dcadd7 100644
> --- a/tools/ndctl/test/dpa-alloc.c
> +++ b/tools/ndctl/test/dpa-alloc.c
> @@ -24,9 +24,9 @@
>  #include <uuid/uuid.h>
>  
>  #include <test.h>
> +#include <util/kernel.h>
>  #include <linux/version.h>
>  #include <ndctl/libndctl.h>
> -#include <ccan/array_size/array_size.h>
>  
>  #ifdef HAVE_NDCTL_H
>  #include <linux/ndctl.h>
> diff --git a/tools/ndctl/test/dsm-fail.c b/tools/ndctl/test/dsm-fail.c
> index 22ec94451146..ee21ca6b7474 100644
> --- a/tools/ndctl/test/dsm-fail.c
> +++ b/tools/ndctl/test/dsm-fail.c
> @@ -20,9 +20,9 @@
>  #include <libkmod.h>
>  #include <util/log.h>
>  #include <util/sysfs.h>
> +#include <util/kernel.h>
>  #include <linux/version.h>
>  
> -#include <ccan/array_size/array_size.h>
>  #include <ndctl/libndctl.h>
>  #ifdef HAVE_NDCTL_H
>  #include <linux/ndctl.h>
> diff --git a/tools/ndctl/test/libndctl.c b/tools/ndctl/test/libndctl.c
> index 50fce70183a8..7091b179ef25 100644
> --- a/tools/ndctl/test/libndctl.c
> +++ b/tools/ndctl/test/libndctl.c
> @@ -28,7 +28,7 @@
>  #include <sys/select.h>
>  #include <linux/version.h>
>  
> -#include <ccan/array_size/array_size.h>
> +#include <util/kernel.h>
>  #include <ndctl/libndctl.h>
>  #include <daxctl/libdaxctl.h>
>  #ifdef HAVE_NDCTL_H
> @@ -2289,7 +2289,6 @@ static int check_smart_threshold(struct ndctl_bus *bus, struct ndctl_dimm *dimm,
>  }
>  #endif
>  
> -#define BITS_PER_LONG 32
>  static int check_commands(struct ndctl_bus *bus, struct ndctl_dimm *dimm,
>  		unsigned long bus_commands, unsigned long dimm_commands,
>  		struct ndctl_test *test)
> diff --git a/tools/ndctl/test/multi-pmem.c b/tools/ndctl/test/multi-pmem.c
> index 3e3c1037e016..9228b9f956bd 100644
> --- a/tools/ndctl/test/multi-pmem.c
> +++ b/tools/ndctl/test/multi-pmem.c
> @@ -23,10 +23,10 @@
>  #include <uuid/uuid.h>
>  #include <sys/types.h>
>  #include <util/size.h>
> +#include <util/kernel.h>
>  #include <linux/falloc.h>
>  #include <linux/version.h>
>  #include <ndctl/libndctl.h>
> -#include <ccan/array_size/array_size.h>
>  
>  #ifdef HAVE_NDCTL_H
>  #include <linux/ndctl.h>
> diff --git a/tools/ndctl/test/pmem_namespaces.c b/tools/ndctl/test/pmem_namespaces.c
> index 94a5986955b3..6260cf6ed8fb 100644
> --- a/tools/ndctl/test/pmem_namespaces.c
> +++ b/tools/ndctl/test/pmem_namespaces.c
> @@ -26,11 +26,10 @@
>  #include <unistd.h>
>  #include <uuid/uuid.h>
>  #include <libkmod.h>
> +#include <util/kernel.h>
>  #include <linux/version.h>
>  #include <test.h>
>  
> -#include <ccan/array_size/array_size.h>
> -
>  #ifdef HAVE_NDCTL_H
>  #include <linux/ndctl.h>
>  #else
> diff --git a/tools/ndctl/util/bitmap.c b/tools/ndctl/util/bitmap.c
> deleted file mode 100644
> index 8df8a3253f10..000000000000
> --- a/tools/ndctl/util/bitmap.c
> +++ /dev/null
> @@ -1,131 +0,0 @@
> -/*
> - * Copyright(c) 2017 Intel Corporation. All rights reserved.
> - * Copyright(c) 2009 Akinobu Mita. All rights reserved.
> - *
> - * This program is free software; you can redistribute it and/or modify it
> - * under the terms of version 2 of the GNU General Public License as
> - * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it will be useful, but
> - * WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> - * General Public License for more details.
> - */
> -
> -/* originally copied from the Linux kernel bitmap implementation */
> -
> -#include <stdlib.h>
> -#include <util/size.h>
> -#include <util/util.h>
> -#include <util/bitmap.h>
> -#include <ccan/endian/endian.h>
> -#include <ccan/minmax/minmax.h>
> -#include <ccan/short_types/short_types.h>
> -
> -unsigned long *bitmap_alloc(unsigned long nbits)
> -{
> -	return calloc(BITS_TO_LONGS(nbits), sizeof(unsigned long));
> -}
> -
> -void bitmap_set(unsigned long *map, unsigned int start, int len)
> -{
> -	unsigned long *p = map + BIT_WORD(start);
> -	const unsigned int size = start + len;
> -	int bits_to_set = BITS_PER_LONG - (start % BITS_PER_LONG);
> -	unsigned long mask_to_set = BITMAP_FIRST_WORD_MASK(start);
> -
> -	while (len - bits_to_set >= 0) {
> -		*p |= mask_to_set;
> -		len -= bits_to_set;
> -		bits_to_set = BITS_PER_LONG;
> -		mask_to_set = ~0UL;
> -		p++;
> -	}
> -	if (len) {
> -		mask_to_set &= BITMAP_LAST_WORD_MASK(size);
> -		*p |= mask_to_set;
> -	}
> -}
> -
> -void bitmap_clear(unsigned long *map, unsigned int start, int len)
> -{
> -	unsigned long *p = map + BIT_WORD(start);
> -	const unsigned int size = start + len;
> -	int bits_to_clear = BITS_PER_LONG - (start % BITS_PER_LONG);
> -	unsigned long mask_to_clear = BITMAP_FIRST_WORD_MASK(start);
> -
> -	while (len - bits_to_clear >= 0) {
> -		*p &= ~mask_to_clear;
> -		len -= bits_to_clear;
> -		bits_to_clear = BITS_PER_LONG;
> -		mask_to_clear = ~0UL;
> -		p++;
> -	}
> -	if (len) {
> -		mask_to_clear &= BITMAP_LAST_WORD_MASK(size);
> -		*p &= ~mask_to_clear;
> -	}
> -}
> -
> -/**
> - * test_bit - Determine whether a bit is set
> - * @nr: bit number to test
> - * @addr: Address to start counting from
> - */
> -int test_bit(unsigned int nr, const volatile unsigned long *addr)
> -{
> -	return 1UL & (addr[BIT_WORD(nr)] >> (nr & (BITS_PER_LONG-1)));
> -}
> -
> -/*
> - * This is a common helper function for find_next_bit and
> - * find_next_zero_bit.  The difference is the "invert" argument, which
> - * is XORed with each fetched word before searching it for one bits.
> - */
> -static unsigned long _find_next_bit(const unsigned long *addr,
> -		unsigned long nbits, unsigned long start, unsigned long invert)
> -{
> -	unsigned long tmp;
> -
> -	if (!nbits || start >= nbits)
> -		return nbits;
> -
> -	tmp = addr[start / BITS_PER_LONG] ^ invert;
> -
> -	/* Handle 1st word. */
> -	tmp &= BITMAP_FIRST_WORD_MASK(start);
> -	start = round_down(start, BITS_PER_LONG);
> -
> -	while (!tmp) {
> -		start += BITS_PER_LONG;
> -		if (start >= nbits)
> -			return nbits;
> -
> -		tmp = addr[start / BITS_PER_LONG] ^ invert;
> -	}
> -
> -	return min(start + __builtin_ffsl(tmp), nbits);
> -}
> -
> -/*
> - * Find the next set bit in a memory region.
> - */
> -unsigned long find_next_bit(const unsigned long *addr, unsigned long size,
> -			    unsigned long offset)
> -{
> -	return _find_next_bit(addr, size, offset, 0UL);
> -}
> -
> -unsigned long find_next_zero_bit(const unsigned long *addr, unsigned long size,
> -				 unsigned long offset)
> -{
> -	return _find_next_bit(addr, size, offset, ~0UL);
> -}
> -
> -int bitmap_full(const unsigned long *src, unsigned int nbits)
> -{
> -	if (small_const_nbits(nbits))
> -		return ! (~(*src) & BITMAP_LAST_WORD_MASK(nbits));
> -
> -	return find_next_zero_bit(src, nbits, 0UL) == nbits;
> -}
> diff --git a/tools/ndctl/util/bitmap.h b/tools/ndctl/util/bitmap.h
> deleted file mode 100644
> index 11ef22cc657b..000000000000
> --- a/tools/ndctl/util/bitmap.h
> +++ /dev/null
> @@ -1,44 +0,0 @@
> -/*
> - * Copyright(c) 2015-2017 Intel Corporation. All rights reserved.
> - *
> - * This program is free software; you can redistribute it and/or modify it
> - * under the terms of version 2 of the GNU General Public License as
> - * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it will be useful, but
> - * WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> - * General Public License for more details.
> - */
> -#ifndef _NDCTL_BITMAP_H_
> -#define _NDCTL_BITMAP_H_
> -
> -#include <util/size.h>
> -#include <ccan/short_types/short_types.h>
> -
> -#define DIV_ROUND_UP(n, d) (((n) + (d) - 1) / (d))
> -
> -#define BIT(nr)			(1UL << (nr))
> -#define BIT_MASK(nr)		(1UL << ((nr) % BITS_PER_LONG))
> -#define BIT_WORD(nr)		((nr) / BITS_PER_LONG)
> -#define BITS_PER_BYTE		8
> -#define BITS_TO_LONGS(nr)	DIV_ROUND_UP(nr, BITS_PER_BYTE * sizeof(long))
> -
> -#define BITMAP_FIRST_WORD_MASK(start) (~0UL << ((start) & (BITS_PER_LONG - 1)))
> -#define BITMAP_LAST_WORD_MASK(nbits) (~0UL >> (-(nbits) & (BITS_PER_LONG - 1)))
> -
> -#define small_const_nbits(nbits) \
> -	(__builtin_constant_p(nbits) && (nbits) <= BITS_PER_LONG)
> -
> -unsigned long *bitmap_alloc(unsigned long nbits);
> -void bitmap_set(unsigned long *map, unsigned int start, int len);
> -void bitmap_clear(unsigned long *map, unsigned int start, int len);
> -int test_bit(unsigned int nr, const volatile unsigned long *addr);
> -unsigned long find_next_bit(const unsigned long *addr, unsigned long size,
> -			    unsigned long offset);
> -unsigned long find_next_zero_bit(const unsigned long *addr, unsigned long size,
> -				 unsigned long offset);
> -int bitmap_full(const unsigned long *src, unsigned int nbits);
> -
> -
> -#endif /* _NDCTL_BITMAP_H_ */
> diff --git a/tools/ndctl/util/json.c b/tools/ndctl/util/json.c
> index 2b2b5af16504..1a70e5c61c88 100644
> --- a/tools/ndctl/util/json.c
> +++ b/tools/ndctl/util/json.c
> @@ -14,12 +14,12 @@
>  #include <string.h>
>  #include <util/json.h>
>  #include <util/filter.h>
> +#include <util/kernel.h>
>  #include <uuid/uuid.h>
>  #include <json-c/json.h>
>  #include <json-c/printbuf.h>
>  #include <ndctl/libndctl.h>
>  #include <daxctl/libdaxctl.h>
> -#include <ccan/array_size/array_size.h>
>  
>  #ifdef HAVE_NDCTL_H
>  #include <linux/ndctl.h>
> diff --git a/tools/ndctl/util/kernel.h b/tools/ndctl/util/kernel.h
> new file mode 100644
> index 000000000000..20557e978c37
> --- /dev/null
> +++ b/tools/ndctl/util/kernel.h
> @@ -0,0 +1,9 @@
> +#ifndef __UTIL_KERNEL_H__
> +#define __UTIL_KERNEL_H__
> +/*
> + * Disable the dummy definition of cpu_to_le64 since we have one
> + * locally from ccan. TODO: uplevel endian helpers to top-level tools/
> + */
> +#define cpu_to_le64 cpu_to_le64
> +#include <linux/kernel.h>
> +#endif /* __UTIL_KERNEL_H__ */
> diff --git a/tools/ndctl/util/list.h b/tools/ndctl/util/list.h
> new file mode 100644
> index 000000000000..c6a348b5dbd2
> --- /dev/null
> +++ b/tools/ndctl/util/list.h
> @@ -0,0 +1,24 @@
> +#ifndef __UTIL_LIST_H__
> +#define __UTIL_LIST_H__
> +#include <util/kernel.h>
> +#include <linux/list.h>
> +
> +#define list_next(head, pos, member) \
> +({ \
> +	typeof(pos) _pos = (pos); \
> +	struct list_head *_head = (head); \
> +	\
> +	_pos = list_next_entry(_pos, member); \
> +	if (&_pos->member == _head) \
> +		_pos = NULL; \
> +	else \
> +		; \
> +	_pos; \
> +})
> +
> +/* TODO: add a debug mode that checks @pos is on @head */
> +static inline void list_del_from(struct list_head *head, struct list_head *node)
> +{
> +	list_del(node);
> +}
> +#endif /* __UTIL_LIST_H__ */
> diff --git a/tools/ndctl/util/parse-options.h b/tools/ndctl/util/parse-options.h
> index 6fd6b2418296..bd7cc658a4bd 100644
> --- a/tools/ndctl/util/parse-options.h
> +++ b/tools/ndctl/util/parse-options.h
> @@ -19,6 +19,7 @@
>  #include <stdbool.h>
>  #include <stdint.h>
>  #include <util/util.h>
> +#include <util/kernel.h>
>  
>  enum parse_opt_type {
>  	/* special types */
> diff --git a/tools/ndctl/util/size.h b/tools/ndctl/util/size.h
> index 3c27079fc2b8..6a5bd239087a 100644
> --- a/tools/ndctl/util/size.h
> +++ b/tools/ndctl/util/size.h
> @@ -28,7 +28,6 @@ unsigned long long parse_size64(const char *str);
>  unsigned long long __parse_size64(const char *str, unsigned long long *units);
>  
>  #define ALIGN(x, a) ((((unsigned long long) x) + (a - 1)) & ~(a - 1))
> -#define BITS_PER_LONG (sizeof(unsigned long) * 8)
>  #define HPAGE_SIZE (2 << 20)
>  
>  #endif /* _NDCTL_SIZE_H_ */
> diff --git a/tools/ndctl/util/util.h b/tools/ndctl/util/util.h
> index 162aade1817d..9f51322e7af6 100644
> --- a/tools/ndctl/util/util.h
> +++ b/tools/ndctl/util/util.h
> @@ -70,7 +70,6 @@
>  
>  #define zfree(ptr) ({ free(*ptr); *ptr = NULL; })
>  
> -#define BUILD_BUG_ON_ZERO(e) (sizeof(struct { int:-!!(e); }))
>  #define BUILD_BUG_ON(condition) ((void)sizeof(char[1 - 2*!!(condition)]))
>  
>  static inline const char *skip_prefix(const char *str, const char *prefix)
> diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
> index 1d639e38aa82..d6e36a12b59c 100644
> --- a/tools/perf/util/util.h
> +++ b/tools/perf/util/util.h
> @@ -23,8 +23,6 @@
>  #endif
>  #endif
>  
> -#define ARRAY_SIZE(x) (sizeof(x)/sizeof(x[0]))
> -
>  #ifdef __GNUC__
>  #define TYPEOF(x) (__typeof__(x))
>  #else
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
