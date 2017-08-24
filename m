Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x232.google.com (mail-oi0-x232.google.com
 [IPv6:2607:f8b0:4003:c06::232])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 201A22095AE45
 for <linux-nvdimm@lists.01.org>; Thu, 24 Aug 2017 10:33:28 -0700 (PDT)
Received: by mail-oi0-x232.google.com with SMTP id r9so1244156oie.3
 for <linux-nvdimm@lists.01.org>; Thu, 24 Aug 2017 10:36:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170824165546.GA3121@infradead.org>
References: <150353211413.5039.5228914877418362329.stgit@dwillia2-desk3.amr.corp.intel.com>
 <150353213097.5039.6729469069608762658.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20170824165546.GA3121@infradead.org>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 24 Aug 2017 10:36:02 -0700
Message-ID: <CAPcyv4iN0QpUSgOUvisnNQsiV1Pp=4dh7CwAV8FFj=_rFU=aug@mail.gmail.com>
Subject: Re: [PATCH v6 3/5] mm: introduce mmap3 for safely defining new mmap
 flags
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
To: Christoph Hellwig <hch@infradead.org>
Cc: Jan Kara <jack@suse.cz>, Arnd Bergmann <arnd@arndb.de>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Linux API <linux-api@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-xfs@vger.kernel.org, Linux MM <linux-mm@kvack.org>, Andy Lutomirski <luto@kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Aug 24, 2017 at 9:55 AM, Christoph Hellwig <hch@infradead.org> wrote:
> On Wed, Aug 23, 2017 at 04:48:51PM -0700, Dan Williams wrote:
>> The mmap(2) syscall suffers from the ABI anti-pattern of not validating
>> unknown flags. However, proposals like MAP_SYNC and MAP_DIRECT need a
>> mechanism to define new behavior that is known to fail on older kernels
>> without the support. Define a new mmap3 syscall that checks for
>> unsupported flags at syscall entry and add a 'mmap_supported_mask' to
>> 'struct file_operations' so generic code can validate the ->mmap()
>> handler knows about the specified flags. This also arranges for the
>> flags to be passed to the handler so it can do further local validation
>> if the requested behavior can be fulfilled.
>
> What is the reason to not go with __MAP_VALID hack?  Adding new
> syscalls is extremely painful, it will take forever to trickle this
> through all architectures (especially with the various 32-bit
> architectures having all kinds of different granularities for the
> offset) and then the various C libraries, never mind applications.

I'll let Andy and Kirill restate their concerns, but one of the
arguments that swayed me is that any new mmap flag with this hack must
be documented to only work with MAP_SHARED and that MAP_PRIVATE is
silently ignored. I agree with the mess and delays it causes for other
archs and libc, but at the same time this is for new applications and
libraries that know to look for the new flag, so they need to do the
extra work to check for the new syscall.

However, if the fcntl lease approach works for the DMA cases then we
only have the one mmap flag to add for now, so maybe the weird
MAP_{SHARED|PRIVATE} semantics are tolerable.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
