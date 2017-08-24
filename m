Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x235.google.com (mail-oi0-x235.google.com
 [IPv6:2607:f8b0:4003:c06::235])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E3A0F2095AE49
 for <linux-nvdimm@lists.01.org>; Thu, 24 Aug 2017 10:39:34 -0700 (PDT)
Received: by mail-oi0-x235.google.com with SMTP id k77so1444930oib.2
 for <linux-nvdimm@lists.01.org>; Thu, 24 Aug 2017 10:42:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170824165838.GB3121@infradead.org>
References: <150353211413.5039.5228914877418362329.stgit@dwillia2-desk3.amr.corp.intel.com>
 <150353211985.5039.4333061601382775843.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20170824165838.GB3121@infradead.org>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 24 Aug 2017 10:42:09 -0700
Message-ID: <CAPcyv4gd1qgtP7DjfRnXDebhYb1_4jnuM3HTL-ma2snz7FMAOg@mail.gmail.com>
Subject: Re: [PATCH v6 1/5] vfs: add flags parameter to ->mmap() in 'struct
 file_operations'
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
Cc: Jan Kara <jack@suse.cz>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, David Airlie <airlied@linux.ie>, Linux API <linux-api@vger.kernel.org>, Takashi Iwai <tiwai@suse.com>, Maling list - DRI developers <dri-devel@lists.freedesktop.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-xfs@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>, Andy Lutomirski <luto@kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Daniel Vetter <daniel.vetter@intel.com>, Andrew Morton <akpm@linux-foundation.org>, Linux MM <linux-mm@kvack.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Aug 24, 2017 at 9:58 AM, Christoph Hellwig <hch@infradead.org> wrote:
> On Wed, Aug 23, 2017 at 04:48:40PM -0700, Dan Williams wrote:
>> We are running running short of vma->vm_flags. We can avoid needing a
>> new VM_* flag in some cases if the original @flags submitted to mmap(2)
>> is made available to the ->mmap() 'struct file_operations'
>> implementation. For example, the proposed addition of MAP_DIRECT can be
>> implemented without taking up a new vm_flags bit. Another motivation to
>> avoid vm_flags is that they appear in /proc/$pid/smaps, and we have seen
>> software that tries to dangerously (TOCTOU) read smaps to infer the
>> behavior of a virtual address range.
>>
>> This conversion was performed by the following semantic patch. There
>> were a few manual edits for oddities like proc_reg_mmap.
>>
>> Thanks to Julia for helping me with coccinelle iteration to cover cases
>> where the mmap routine is defined in a separate file from the 'struct
>> file_operations' instance that consumes it.
>
> How are we going to check that an instance actually supports any
> of those flags?

In patch 3 I validate the flags by introducing an
"mmap_supported_mask" field to 'struct file_operations'. It will be
zero by default for almost all implementations and zero means "support
the legacy mmap flags".
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
