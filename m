Return-Path: <linux-kernel-owner@vger.kernel.org>
Message-ID: <1424751767.9050.4.camel@intel.com>
Subject: Re: [PATCH 1/3] e820: Don't let unknown DIMM type come out BUSY
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 23 Feb 2015 20:22:47 -0800
In-Reply-To: <54EB1E03.4010306@plexistor.com>
References: <54EB1D33.3050107@plexistor.com>
	 <54EB1E03.4010306@plexistor.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: Boaz Harrosh <boaz@plexistor.com>
Cc: Ingo Molnar <mingo@redhat.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, x86@kernel.org, linux-kernel <linux-kernel@vger.kernel.org>, "Roger C. Pao" <rcpao.enmotus@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, Linus Torvalds <torvalds@linux-foundation.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, "H. Peter Anvin" <hpa@zytor.com>, Matthew Wilcox <willy@linux.intel.com>, Andy Lutomirski <luto@amacapital.net>, Christoph Hellwig <hch@infradead.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, 2015-02-23 at 14:33 +0200, Boaz Harrosh wrote:
> There is something not very nice (Gentlemen nice) In current
> e820.c code.
> 
> At Multiple places for example like (@ memblock_x86_fill()) it will
> add the different memory resources *except the E820_RESERVED type*
> 
> Then at e820_reserve_resources() it will mark all !E820_RESERVED
> as busy.
> 
> This is all fine when we have only the known types one of:
> 	E820_RESERVED_KERN:
> 	E820_RAM:
> 	E820_ACPI:
> 	E820_NVS:
> 	E820_UNUSABLE:
> 	E820_RESERVED:
> 
> But if the system encounters a brand new memory type it will
> not add it to any memory list, But will proceed to mark it
> BUSY. So now any other Driver in the system that does know
> how to deal with this new type, is not able to call
> request_mem_region_exclusive() on this new type because it is
> hard coded BUSY even though nothing really uses it.
> 
> So make any unknown type behave like E820_RESERVED memory,
> it will show up as available to first caller of
> request_mem_region_exclusive().
> 
> I Also change the string representation of an unknown type
> from "reserved" (So to not confuse with memmap "reserved"
> region). And call it "reserved-unknown"
> I wish I could return "reserved-type-X" But this is not possible
> because one must return a constant, code-segment, string.
> 
> (NOTE: These unknown-types where called "reserved" in
>  /proc/iomem and in dmesg but behaved differently. What this
>  patch does is name them differently but let them behave
>  the same)
> 
> By Popular demand An Extra WARNING message is printed if
> an "UNKNOWN" is found. It will look like this:
>   e820: WARNING [mem 0x100000000-0x1ffffffff] is unknown type 12

I don't think we need to warn that an unknown range was published, just
warn if it is consumed.

Something like these incremental changes.  I don't see the need for
patch 2 or either version of patch 3.

diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index 1afa5518baa6..2e755a92d84f 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -134,11 +134,6 @@ static void __init __e820_add_region(struct e820map *e820x, u64 start, u64 size,
 		return;
 	}
 
-	if (unlikely(_is_unknown_type(type)))
-		pr_warn("e820: WARNING [mem %#010llx-%#010llx] is unknown type %d\n",
-		       (unsigned long long) start,
-		       (unsigned long long) (start + size - 1), type);
-
 	e820x->map[x].addr = start;
 	e820x->map[x].size = size;
 	e820x->map[x].type = type;
@@ -938,7 +933,7 @@ static inline const char *e820_type_to_string(int e820_type)
 	case E820_NVS:	return "ACPI Non-volatile Storage";
 	case E820_UNUSABLE:	return "Unusable memory";
 	case E820_RESERVED:	return "reserved";
-	default:	return "reserved-unkown";
+	default:	return iomem_unknown_resource_name;
 	}
 }
 
diff --git a/include/linux/ioport.h b/include/linux/ioport.h
index 2c5250222278..d857e79b4bf2 100644
--- a/include/linux/ioport.h
+++ b/include/linux/ioport.h
@@ -194,6 +194,9 @@ extern struct resource * __request_region(struct resource *,
 					resource_size_t n,
 					const char *name, int flags);
 
+/* For uniquely tagging unknown memory so we can warn when it is consumed */
+extern const char iomem_unknown_resource_name[];
+
 /* Compatibility cruft */
 #define release_region(start,n)	__release_region(&ioport_resource, (start), (n))
 #define check_mem_region(start,n)	__check_region(&iomem_resource, (start), (n))
diff --git a/kernel/resource.c b/kernel/resource.c
index 0bcebffc4e77..38b36c212a48 100644
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -1040,6 +1040,8 @@ resource_size_t resource_alignment(struct resource *res)
 
 static DECLARE_WAIT_QUEUE_HEAD(muxed_resource_wait);
 
+const char iomem_unknown_resource_name[] = { "reserved-unknown" };
+
 /**
  * __request_region - create a new busy resource region
  * @parent: parent resource descriptor
@@ -1092,6 +1094,15 @@ struct resource * __request_region(struct resource *parent,
 		break;
 	}
 	write_unlock(&resource_lock);
+
+	if (res && res->parent
+			&& res->parent->name == iomem_unknown_resource_name) {
+		add_taint(TAINT_FIRMWARE_WORKAROUND, LOCKDEP_STILL_OK);
+		pr_warn("request unknown region [mem %#010llx-%#010llx] %s\n",
+				res->start, res->end,
+				res->name);
+	}
+
 	return res;
 }
 EXPORT_SYMBOL(__request_region);


