Return-Path: <linux-kernel-owner@vger.kernel.org>
Message-ID: <54EC2F4E.1080606@plexistor.com>
Date: Tue, 24 Feb 2015 09:59:10 +0200
From: Boaz Harrosh <boaz@plexistor.com>
MIME-Version: 1.0
Subject: Re: [PATCH 1/3] e820: Don't let unknown DIMM type come out BUSY
References: <54EB1D33.3050107@plexistor.com>	 <54EB1E03.4010306@plexistor.com> <1424751767.9050.4.camel@intel.com>
In-Reply-To: <1424751767.9050.4.camel@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Ingo Molnar <mingo@redhat.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, x86@kernel.org, linux-kernel <linux-kernel@vger.kernel.org>, "Roger C. Pao" <rcpao.enmotus@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, Linus Torvalds <torvalds@linux-foundation.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, "H. Peter Anvin" <hpa@zytor.com>, Matthew Wilcox <willy@linux.intel.com>, Andy Lutomirski <luto@amacapital.net>, Christoph Hellwig <hch@infradead.org>
List-ID: <linux-nvdimm@lists.01.org>

On 02/24/2015 06:22 AM, Dan Williams wrote:
<>
>> By Popular demand An Extra WARNING message is printed if
>> an "UNKNOWN" is found. It will look like this:
>>   e820: WARNING [mem 0x100000000-0x1ffffffff] is unknown type 12
> 
> I don't think we need to warn that an unknown range was published, just
> warn if it is consumed.
> 

I did not have it at first, Ingo asked for it. I don't mind having
it and I don't mind not. I'd say it is Ingo's call.

> Something like these incremental changes.  I don't see the need for
> patch 2 or either version of patch 3.
> 
> diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
> index 1afa5518baa6..2e755a92d84f 100644
> --- a/arch/x86/kernel/e820.c
> +++ b/arch/x86/kernel/e820.c
> @@ -134,11 +134,6 @@ static void __init __e820_add_region(struct e820map *e820x, u64 start, u64 size,
>  		return;
>  	}
>  
> -	if (unlikely(_is_unknown_type(type)))
> -		pr_warn("e820: WARNING [mem %#010llx-%#010llx] is unknown type %d\n",
> -		       (unsigned long long) start,
> -		       (unsigned long long) (start + size - 1), type);
> -

Again Ingo's call

>  	e820x->map[x].addr = start;
>  	e820x->map[x].size = size;
>  	e820x->map[x].type = type;
> @@ -938,7 +933,7 @@ static inline const char *e820_type_to_string(int e820_type)
>  	case E820_NVS:	return "ACPI Non-volatile Storage";
>  	case E820_UNUSABLE:	return "Unusable memory";
>  	case E820_RESERVED:	return "reserved";
> -	default:	return "reserved-unkown";
> +	default:	return iomem_unknown_resource_name;
>  	}
>  }
>  
> diff --git a/include/linux/ioport.h b/include/linux/ioport.h
> index 2c5250222278..d857e79b4bf2 100644
> --- a/include/linux/ioport.h
> +++ b/include/linux/ioport.h
> @@ -194,6 +194,9 @@ extern struct resource * __request_region(struct resource *,
>  					resource_size_t n,
>  					const char *name, int flags);
>  
> +/* For uniquely tagging unknown memory so we can warn when it is consumed */
> +extern const char iomem_unknown_resource_name[];
> +
>  /* Compatibility cruft */
>  #define release_region(start,n)	__release_region(&ioport_resource, (start), (n))
>  #define check_mem_region(start,n)	__check_region(&iomem_resource, (start), (n))
> diff --git a/kernel/resource.c b/kernel/resource.c
> index 0bcebffc4e77..38b36c212a48 100644
> --- a/kernel/resource.c
> +++ b/kernel/resource.c
> @@ -1040,6 +1040,8 @@ resource_size_t resource_alignment(struct resource *res)
>  
>  static DECLARE_WAIT_QUEUE_HEAD(muxed_resource_wait);
>  
> +const char iomem_unknown_resource_name[] = { "reserved-unknown" };
> +
>  /**
>   * __request_region - create a new busy resource region
>   * @parent: parent resource descriptor
> @@ -1092,6 +1094,15 @@ struct resource * __request_region(struct resource *parent,
>  		break;
>  	}
>  	write_unlock(&resource_lock);
> +
> +	if (res && res->parent
> +			&& res->parent->name == iomem_unknown_resource_name) {

No, this is a complete HACK, since when do we hard code specific (GLOBAL)
ARCHs strings in common code. Please look at linux/ioport.h see the richness 
of options for all kind of buses and systems. The flag system works perfectly
and I just continue this here.

And really DAN, you prefer a global string that's dead garbage in 99% of arches
to a simple bit flag definition that costs nothing? I don't think so.

> +		add_taint(TAINT_FIRMWARE_WORKAROUND, LOCKDEP_STILL_OK);

NACK!!

> +		pr_warn("request unknown region [mem %#010llx-%#010llx] %s\n",
> +				res->start, res->end,
> +				res->name);
> +	}
> +
>  	return res;
>  }
>  EXPORT_SYMBOL(__request_region);
> 
> 

I do not understand you guys. Really. Dan you are a Linux Kernel developer
why do you want to go ask some committee an approval for each new type of
device that you want to develop. Why not have a system where the BIOS just
puts up a BAR and an ID, and the rest is up to the drivers you write in C
in the Kernel? What is the motivation of the complication? I would really
like to understand?

Thanks
Boaz

