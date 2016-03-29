Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-wm0-x241.google.com (mail-wm0-x241.google.com
 [IPv6:2a00:1450:400c:c09::241])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4F09F1A1EE9
 for <linux-nvdimm@lists.01.org>; Tue, 29 Mar 2016 01:38:49 -0700 (PDT)
Received: by mail-wm0-x241.google.com with SMTP id 139so3103854wmn.2
 for <linux-nvdimm@lists.01.org>; Tue, 29 Mar 2016 01:38:20 -0700 (PDT)
Date: Tue, 29 Mar 2016 10:38:15 +0200
From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH v3] x86, pmem: use memcpy_mcsafe() for memcpy_from_pmem()
Message-ID: <20160329083815.GB27941@gmail.com>
References: <20160329002845.10978.8879.stgit@dwillia2-desk3.jf.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160329002845.10978.8879.stgit@dwillia2-desk3.jf.intel.com>
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
Cc: Tony Luck <tony.luck@intel.com>, linux-nvdimm@lists.01.org, Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>, Borislav Petkov <bp@alien8.de>, Thomas Gleixner <tglx@linutronix.de>, Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>


* Dan Williams <dan.j.williams@intel.com> wrote:

> Update the definition of memcpy_from_pmem() to return 0 or a negative
> error code.  Implement x86/arch_memcpy_from_pmem() with memcpy_mcsafe().
> 
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Tony Luck <tony.luck@intel.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Andy Lutomirski <luto@amacapital.net>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

I suspect you want to carry this in the nvdimm tree? If so:

  Acked-by: Ingo Molnar <mingo@kernel.org>

Thanks,

	Ingo

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
