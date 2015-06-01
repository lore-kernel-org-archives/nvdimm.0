Return-Path: <owner-linux-mm@kvack.org>
Message-ID: <556C4593.5090600@plexistor.com>
Date: Mon, 01 Jun 2015 14:44:19 +0300
From: Boaz Harrosh <boaz@plexistor.com>
MIME-Version: 1.0
Subject: Re: [PATCH v2 4/4] arch, x86: cache management apis for persistent
 memory
References: <20150530185425.32590.3190.stgit@dwillia2-desk3.amr.corp.intel.com> <20150530185940.32590.37804.stgit@dwillia2-desk3.amr.corp.intel.com> <556C4477.8090803@plexistor.com>
In-Reply-To: <556C4477.8090803@plexistor.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: owner-linux-mm@kvack.org
To: Dan Williams <dan.j.williams@intel.com>, arnd@arndb.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com, tglx@linutronix.de, ross.zwisler@linux.intel.com, akpm@linux-foundation.org
Cc: jgross@suse.com, konrad.wilk@oracle.com, mcgrof@suse.com, x86@kernel.org, linux-kernel@vger.kernel.org, stefan.bader@canonical.com, luto@amacapital.net, linux-mm@kvack.org, linux-nvdimm@lists.01.org, geert@linux-m68k.org, hmh@hmh.eng.br, tj@kernel.org, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

Forgot one thing

On 06/01/2015 02:39 PM, Boaz Harrosh wrote:
>> +static inline void persistent_copy(void *dst, const void *src, size_t n)

Could we please make this
memcpy_persistent

Same as:
copy_from_user_nocache

The generic name of what it does first then the special override.
copy_from_user_XXX is same as copy_from_user but with XXX applied

Same here exactly as memcpy_ but with persistent applied.

<>

Thanks
Boaz

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
