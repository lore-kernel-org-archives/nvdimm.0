Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B303421290DE1
 for <linux-nvdimm@lists.01.org>; Fri,  7 Jun 2019 12:57:50 -0700 (PDT)
Subject: Re: [PATCH v3 00/10] EFI Specific Purpose Memory Support
References: <155993563277.3036719.17400338098057706494.stgit@dwillia2-desk3.amr.corp.intel.com>
From: Dave Hansen <dave.hansen@intel.com>
Message-ID: <86a49d1a-678e-5e86-180b-e48326d1bdb5@intel.com>
Date: Fri, 7 Jun 2019 12:57:49 -0700
MIME-Version: 1.0
In-Reply-To: <155993563277.3036719.17400338098057706494.stgit@dwillia2-desk3.amr.corp.intel.com>
Content-Language: en-US
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
To: Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org
Cc: linux-efi@vger.kernel.org, x86@kernel.org, kbuild test robot <lkp@intel.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Peter Zijlstra <peterz@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Matthew Wilcox <willy@infradead.org>, Dave Hansen <dave.hansen@linux.intel.com>, linux-nvdimm@lists.01.org, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Andy Lutomirski <luto@kernel.org>, Jonathan Cameron <Jonathan.Cameron@huawei.com>, Darren Hart <dvhart@infradead.org>, Thomas Gleixner <tglx@linutronix.de>, Andy Shevchenko <andy@infradead.org>, Len Brown <lenb@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On 6/7/19 12:27 PM, Dan Williams wrote:
> In support of optionally allowing either application-exclusive and
> core-kernel-mm managed access to differentiated memory, claim
> EFI_MEMORY_SP ranges for exposure as device-dax instances by default.
> Such instances can be directly owned / mapped by a
> platform-topology-aware application. Alternatively, with the new kmem
> facility [4], the administrator has the option to instead designate that
> those memory ranges be hot-added to the core-kernel-mm as a unique
> memory numa-node. In short, allow for the decision about what software
> agent manages specific-purpose memory to be made at runtime.

It's probably worth noting that the reason the memory lands into the
state of being controlled by device-dax by default is that device-dax is
nice.  It's actually willing and able to give up ownership of the memory
when we ask.  If we added to the core-mm, we'd almost certainly not be
able to get it back reliably.

Anyway, thanks for doing these, and I really hope that the world's
BIOSes actually use this flag.  For the series:

Reviewed-by: Dave Hansen <dave.hansen@linux.intel.com>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
