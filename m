Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-it0-x241.google.com (mail-it0-x241.google.com
 [IPv6:2607:f8b0:4001:c0b::241])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 397392274F3DF
 for <linux-nvdimm@lists.01.org>; Thu, 12 Apr 2018 15:51:02 -0700 (PDT)
Received: by mail-it0-x241.google.com with SMTP id r19-v6so980290itc.0
 for <linux-nvdimm@lists.01.org>; Thu, 12 Apr 2018 15:51:01 -0700 (PDT)
MIME-Version: 1.0
References: <20180215210932.15490-1-erik.schmauss@intel.com>
 <20180215210932.15490-6-erik.schmauss@intel.com>
In-Reply-To: <20180215210932.15490-6-erik.schmauss@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 12 Apr 2018 22:50:49 +0000
Message-ID: <CAA9_cmftDhE4dbEAPSXhW2DY2j_toWmsU2E-NJ6cG3Vd0MdXVw@mail.gmail.com>
Subject: Re: [PATCH v2 5/7] ACPICA: Integrate package handling with
 module-level code
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
To: erik.schmauss@intel.com
Cc: Linux ACPI <linux-acpi@vger.kernel.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Bob Moore <robert.moore@intel.com>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

[ adding linux-nvdimm ]

On Fri, Feb 16, 2018 at 7:20 AM Erik Schmauss <erik.schmauss@intel.com>
wrote:

> ACPICA commit 8faf6fca445eb7219963d80543fb802302a7a8c7

> This change completes the integration of the recent changes to
> package object handling with the module-level code support.

> For acpi_exec, the -ep flag is removed.

> This change allows table load to behave as if it were a method
> invocation. Before this, the definition block definition below would
> have loaded all named objects at the root scope. After loading, it
> would execute the if statements at the root scope.

> DefinitionBlock (...)
> {
>    Name(OBJ1, 0)

>    if (1)
>    {
>      Device (DEV1)
>      {
>        Name (_HID,0x0)
>      }
>    }
>    Scope (DEV1)
>    {
>      Name (OBJ2)
>    }
> }

> The above code would load OBJ1 to the namespace, defer the execution
> of the if statement and attempt to add OBJ2 within the scope of DEV1.
> Since DEV1 is not in scope, this would incur an AE_NOT_FOUND error.
> After this error is emitted, the if block is invoked and DEV1 and its
> _HID is added to the namespace.

> This commit changes the behavior to execute the if block in place
> rather than deferring it until all tables are loaded. The new
> behavior is as follows: insert OBJ1 in the namespace, invoke the if
> statement and add DEV1 and its _HID to the namespace, add OBJ2 to the
> scope of DEV1.

> Bug report links:
> Link: https://bugs.acpica.org/show_bug.cgi?id=963
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=153541
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=196165
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=192621
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=197207
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=198051
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=198515

> ACPICA repo:
> Link: https://github.com/acpica/acpica/commit/8faf6fca

> Tested-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
> Signed-off-by: Bob Moore <robert.moore@intel.com>
> Signed-off-by: Erik Schmauss <erik.schmauss@intel.com>

Hi,

This commit 5a8361f7ecce ("ACPICA: Integrate package handling with
module-level code") regresses the detection of persistent memory in my
qemu-kvm setup.

Expect:

# ndctl list -BR
[
   {
     "provider":"ACPI.NFIT",
     "dev":"ndbus1",
     "regions":[
       {
         "dev":"region1",
         "size":33285996544,
         "available_size":0,
         "type":"pmem",
         "numa_node":0,
         "iset_id":52512752653219036,
         "persistence_domain":"unknown"
       },
       {
         "dev":"region2",
         "size":33285996544,
         "available_size":0,
         "type":"pmem",
         "numa_node":0,
         "iset_id":52512795602891997,
         "persistence_domain":"unknown"
       }
     ]
   },
   {
     "provider":"e820",
     "dev":"ndbus0",
     "regions":[
       {
         "dev":"region0",
         "size":4294967296,
         "available_size":0,
         "type":"pmem",
         "persistence_domain":"unknown"
       }
     ]
   }
]

Actual:

# ndctl list -BR
{
   "provider":"e820",
   "dev":"ndbus0",
   "regions":[
     {
       "dev":"region0",
       "size":4294967296,
       "available_size":0,
       "type":"pmem",
       "persistence_domain":"unknown"
     }
   ]
}

The immediately preceding commit 7decc66df940 ("ACPICA: Revert "Fix for
implicit result conversion for the To____ functions"") works fine.

Commit 5a8361f7ecce does not revert cleanly. Here is my qemu-kvm command
line:

label_size=$((128*1024))
mem_size=$((31 << 30))

kvm=(
         $qemu
         -enable-kvm
         -cpu kvm64
         -kernel $kernel
         -initrd $initrd
         -m 16G,slots=4,maxmem=128G

         -machine pc-i440fx-2.4,accel=kvm,usb=off,vmport=off,nvdimm
         -cpu SandyBridge
         -smp 40
         -netdev tap,id=hostnet0,ifname=tap0,script=no,downscript=no
         -device
virtio-net-pci,netdev=hostnet0,id=net0,mac=52:54:00:b7:a1:ad,bus=pci.0,addr=0x7
         -object
memory-backend-file,id=mem1,share,mem-path=${mem}1,size=$((label_size +
mem_size))
         -device nvdimm,memdev=mem1,id=nv1,label-size=${label_size}

         -object
memory-backend-file,id=mem2,share,mem-path=${mem}2,size=$((label_size +
mem_size))
         -device nvdimm,memdev=mem2,id=nv2,label-size=${label_size}
         -numa node
         -numa node
         -device ahci,id=sata0,bus=pci.0,addr=0x8
         -drive file=$IMAGE,if=none,id=drive-sata0-0-0,format=raw
         -device ide-hd,bus=sata0.0,drive=drive-sata0-0-0,id=sata0-0-0
         -boot order=nc
         -no-reboot
         -watchdog i6300esb
         -rtc base=localtime
         -serial stdio
         -display none
         -monitor null
)

...where the important lines that setup the pmem emulation are:

         -object
memory-backend-file,id=mem1,share,mem-path=${mem}1,size=$((label_size +
mem_size))
         -device nvdimm,memdev=mem1,id=nv1,label-size=${label_size}

         -object
memory-backend-file,id=mem2,share,mem-path=${mem}2,size=$((label_size +
mem_size))
         -device nvdimm,memdev=mem2,id=nv2,label-size=${label_size}

My qemu-kvm version is: v2.7.0-1059-g63e18bdfd8a0

Let me know if you need any more information or help getting the kvm setup
going.


> ---
>   drivers/acpi/acpica/dspkginit.c | 128
++++++++++++++++++++++------------------
>   drivers/acpi/acpica/dswexec.c   |   6 +-
>   drivers/acpi/acpica/nsparse.c   |   5 +-
>   drivers/acpi/acpica/pstree.c    |   1 +
>   include/acpi/acpixf.h           |   8 ++-
>   5 files changed, 85 insertions(+), 63 deletions(-)

> diff --git a/drivers/acpi/acpica/dspkginit.c
b/drivers/acpi/acpica/dspkginit.c
> index 902bee78036c..a307a07aeacd 100644
> --- a/drivers/acpi/acpica/dspkginit.c
> +++ b/drivers/acpi/acpica/dspkginit.c
> @@ -47,6 +47,7 @@
>   #include "amlcode.h"
>   #include "acdispat.h"
>   #include "acinterp.h"
> +#include "acparser.h"

>   #define _COMPONENT          ACPI_NAMESPACE
>   ACPI_MODULE_NAME("dspkginit")
> @@ -94,12 +95,19 @@ acpi_ds_build_internal_package_obj(struct
acpi_walk_state *walk_state,
>          union acpi_parse_object *parent;
>          union acpi_operand_object *obj_desc = NULL;
>          acpi_status status = AE_OK;
> +       u8 module_level_code = FALSE;
>          u16 reference_count;
>          u32 index;
>          u32 i;

>          ACPI_FUNCTION_TRACE(ds_build_internal_package_obj);

> +       /* Check if we are executing module level code */
> +
> +       if (walk_state->parse_flags & ACPI_PARSE_MODULE_LEVEL) {
> +               module_level_code = TRUE;
> +       }
> +
>          /* Find the parent of a possibly nested package */

>          parent = op->common.parent;
> @@ -130,24 +138,44 @@ acpi_ds_build_internal_package_obj(struct
acpi_walk_state *walk_state,

>          /*
>           * Allocate the element array (array of pointers to the individual
> -        * objects) based on the num_elements parameter. Add an extra
pointer slot
> -        * so that the list is always null terminated.
> +        * objects) if necessary. the count is based on the num_elements
> +        * parameter. Add an extra pointer slot so that the list is always
> +        * null terminated.
>           */
> -       obj_desc->package.elements = ACPI_ALLOCATE_ZEROED(((acpi_size)
> -                                                          element_count +
> -                                                          1) *
sizeof(void *));
> -
>          if (!obj_desc->package.elements) {
> -               acpi_ut_delete_object_desc(obj_desc);
> -               return_ACPI_STATUS(AE_NO_MEMORY);
> +               obj_desc->package.elements =
ACPI_ALLOCATE_ZEROED(((acpi_size)
> +
  element_count
> +                                                                  +
> +                                                                  1) *
> +
sizeof(void
> +
  *));
> +
> +               if (!obj_desc->package.elements) {
> +                       acpi_ut_delete_object_desc(obj_desc);
> +                       return_ACPI_STATUS(AE_NO_MEMORY);
> +               }
> +
> +               obj_desc->package.count = element_count;
>          }

> -       obj_desc->package.count = element_count;
> +       /* First arg is element count. Second arg begins the initializer
list */
> +
>          arg = op->common.value.arg;
>          arg = arg->common.next;

> -       if (arg) {
> -               obj_desc->package.flags |= AOPOBJ_DATA_VALID;
> +       /*
> +        * If we are executing module-level code, we will defer the
> +        * full resolution of the package elements in order to support
> +        * forward references from the elements. This provides
> +        * compatibility with other ACPI implementations.
> +        */
> +       if (module_level_code) {
> +               obj_desc->package.aml_start = walk_state->aml;
> +               obj_desc->package.aml_length = 0;
> +
> +               ACPI_DEBUG_PRINT_RAW((ACPI_DB_PARSE,
> +                                     "%s: Deferring resolution of
Package elements\n",
> +                                     ACPI_GET_FUNCTION_NAME));
>          }

>          /*
> @@ -187,15 +215,19 @@ acpi_ds_build_internal_package_obj(struct
acpi_walk_state *walk_state,
>                                              "****DS namepath not found"));
>                          }

> -                       /*
> -                        * Initialize this package element. This function
handles the
> -                        * resolution of named references within the
package.
> -                        */
> -                       acpi_ds_init_package_element(0,
> -                                                    obj_desc->package.
> -                                                    elements[i], NULL,
> -                                                    &obj_desc->package.
> -                                                    elements[i]);
> +                       if (!module_level_code) {
> +                               /*
> +                                * Initialize this package element. This
function handles the
> +                                * resolution of named references within
the package.
> +                                * Forward references from module-level
code are deferred
> +                                * until all ACPI tables are loaded.
> +                                */
> +                               acpi_ds_init_package_element(0,
> +
  obj_desc->package.
> +                                                            elements[i],
NULL,
> +
  &obj_desc->package.
> +                                                            elements[i]);
> +                       }
>                  }

>                  if (*obj_desc_ptr) {
> @@ -265,15 +297,21 @@ acpi_ds_build_internal_package_obj(struct
acpi_walk_state *walk_state,
>                   * num_elements count.
>                   *
>                   * Note: this is not an error, the package is padded out
> -                * with NULLs.
> +                * with NULLs as per the ACPI specification.
>                   */
> -               ACPI_DEBUG_PRINT((ACPI_DB_INFO,
> -                                 "Package List length (%u) smaller than
NumElements "
> -                                 "count (%u), padded with null
elements\n",
> -                                 i, element_count));
> +               ACPI_DEBUG_PRINT_RAW((ACPI_DB_INFO,
> +                                     "%s: Package List length (%u)
smaller than NumElements "
> +                                     "count (%u), padded with null
elements\n",
> +                                     ACPI_GET_FUNCTION_NAME, i,
> +                                     element_count));
> +       }
> +
> +       /* Module-level packages will be resolved later */
> +
> +       if (!module_level_code) {
> +               obj_desc->package.flags |= AOPOBJ_DATA_VALID;
>          }

> -       obj_desc->package.flags |= AOPOBJ_DATA_VALID;
>          op->common.node = ACPI_CAST_PTR(struct acpi_namespace_node,
obj_desc);
>          return_ACPI_STATUS(status);
>   }
> @@ -363,6 +401,10 @@ acpi_ds_resolve_package_element(union
acpi_operand_object **element_ptr)
>          /* Check if reference element is already resolved */

>          if (element->reference.resolved) {
> +               ACPI_DEBUG_PRINT_RAW((ACPI_DB_PARSE,
> +                                     "%s: Package element is already
resolved\n",
> +                                     ACPI_GET_FUNCTION_NAME));
> +
>                  return_VOID;
>          }

> @@ -383,7 +425,10 @@ acpi_ds_resolve_package_element(union
acpi_operand_object **element_ptr)
>                                  "Could not find/resolve named package
element: %s",
>                                  external_path));

> +               /* Not found, set the element to NULL */
> +
>                  ACPI_FREE(external_path);
> +               acpi_ut_remove_reference(*element_ptr);
>                  *element_ptr = NULL;
>                  return_VOID;
>          } else if (resolved_node->type == ACPI_TYPE_ANY) {
> @@ -397,23 +442,6 @@ acpi_ds_resolve_package_element(union
acpi_operand_object **element_ptr)
>                  *element_ptr = NULL;
>                  return_VOID;
>          }
> -#if 0
> -       else if (resolved_node->flags & ANOBJ_TEMPORARY) {
> -               /*
> -                * A temporary node found here indicates that the
reference is
> -                * to a node that was created within this method. We are
not
> -                * going to allow it (especially if the package is
returned
> -                * from the method) -- the temporary node will be deleted
out
> -                * from under the method. (05/2017).
> -                */
> -               ACPI_ERROR((AE_INFO,
> -                           "Package element refers to a temporary name
[%4.4s], "
> -                           "inserting a NULL element",
> -                           resolved_node->name.ascii));
> -               *element_ptr = NULL;
> -               return_VOID;
> -       }
> -#endif

>          /*
>           * Special handling for Alias objects. We need resolved_node to
point
> @@ -449,20 +477,6 @@ acpi_ds_resolve_package_element(union
acpi_operand_object **element_ptr)
>          if (ACPI_FAILURE(status)) {
>                  return_VOID;
>          }
> -#if 0
> -/* TBD - alias support */
> -       /*
> -        * Special handling for Alias objects. We need to setup the type
> -        * and the Op->Common.Node to point to the Alias target. Note,
> -        * Alias has at most one level of indirection internally.
> -        */
> -       type = op->common.node->type;
> -       if (type == ACPI_TYPE_LOCAL_ALIAS) {
> -               type = obj_desc->common.type;
> -               op->common.node = ACPI_CAST_PTR(struct
acpi_namespace_node,
> -                                               op->common.node->object);
> -       }
> -#endif

>          switch (type) {
>                  /*
> diff --git a/drivers/acpi/acpica/dswexec.c b/drivers/acpi/acpica/dswexec.c
> index 2c07d220a50f..46962e34fc02 100644
> --- a/drivers/acpi/acpica/dswexec.c
> +++ b/drivers/acpi/acpica/dswexec.c
> @@ -576,8 +576,10 @@ acpi_status acpi_ds_exec_end_op(struct
acpi_walk_state *walk_state)
>                  case AML_TYPE_CREATE_OBJECT:

>                          ACPI_DEBUG_PRINT((ACPI_DB_EXEC,
> -                                         "Executing CreateObject
(Buffer/Package) Op=%p AMLPtr=%p\n",
> -                                         op, op->named.data));
> +                                         "Executing CreateObject
(Buffer/Package) Op=%p Child=%p ParentOpcode=%4.4X\n",
> +                                         op, op->named.value.arg,
> +                                         op->common.parent->common.
> +                                         aml_opcode));

>                          switch (op->common.parent->common.aml_opcode) {
>                          case AML_NAME_OP:
> diff --git a/drivers/acpi/acpica/nsparse.c b/drivers/acpi/acpica/nsparse.c
> index 6ac2d26a2cfb..acb1aede720e 100644
> --- a/drivers/acpi/acpica/nsparse.c
> +++ b/drivers/acpi/acpica/nsparse.c
> @@ -267,8 +267,9 @@ acpi_ns_parse_table(u32 table_index, struct
acpi_namespace_node *start_node)
>          ACPI_FUNCTION_TRACE(ns_parse_table);

>          if (acpi_gbl_parse_table_as_term_list) {
> -               ACPI_DEBUG_PRINT((ACPI_DB_PARSE,
> -                                 "**** Start table execution pass\n"));
> +               ACPI_DEBUG_PRINT_RAW((ACPI_DB_PARSE,
> +                                     "%s: **** Start table execution
pass\n",
> +                                     ACPI_GET_FUNCTION_NAME));

>                  status = acpi_ns_execute_table(table_index, start_node);
>                  if (ACPI_FAILURE(status)) {
> diff --git a/drivers/acpi/acpica/pstree.c b/drivers/acpi/acpica/pstree.c
> index f9fa88c79b32..a4dd08eca47c 100644
> --- a/drivers/acpi/acpica/pstree.c
> +++ b/drivers/acpi/acpica/pstree.c
> @@ -295,6 +295,7 @@ union acpi_parse_object *acpi_ps_get_child(union
acpi_parse_object *op)

>          case AML_BUFFER_OP:
>          case AML_PACKAGE_OP:
> +       case AML_VARIABLE_PACKAGE_OP:
>          case AML_METHOD_OP:
>          case AML_IF_OP:
>          case AML_WHILE_OP:
> diff --git a/include/acpi/acpixf.h b/include/acpi/acpixf.h
> index c2bf1255f5aa..84c946882589 100644
> --- a/include/acpi/acpixf.h
> +++ b/include/acpi/acpixf.h
> @@ -192,15 +192,19 @@ ACPI_INIT_GLOBAL(u8, acpi_gbl_do_not_use_xsdt,
FALSE);

>   /*
>    * Optionally support group module level code.
> + * NOTE, this is essentially obsolete and will be removed soon
> + * (01/2018).
>    */
> -ACPI_INIT_GLOBAL(u8, acpi_gbl_group_module_level_code, TRUE);
> +ACPI_INIT_GLOBAL(u8, acpi_gbl_group_module_level_code, FALSE);

>   /*
>    * Optionally support module level code by parsing the entire table as
>    * a term_list. Default is FALSE, do not execute entire table until some
>    * lock order issues are fixed.
> + * NOTE, this is essentially obsolete and will be removed soon
> + * (01/2018).
>    */
> -ACPI_INIT_GLOBAL(u8, acpi_gbl_parse_table_as_term_list, FALSE);
> +ACPI_INIT_GLOBAL(u8, acpi_gbl_parse_table_as_term_list, TRUE);

>   /*
>    * Optionally use 32-bit FADT addresses if and when there is a conflict
> --
> 2.14.3

> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
