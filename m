Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-wm0-x242.google.com (mail-wm0-x242.google.com
 [IPv6:2a00:1450:400c:c09::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7FED0210C123D
 for <linux-nvdimm@lists.01.org>; Tue, 24 Jul 2018 00:40:03 -0700 (PDT)
Received: by mail-wm0-x242.google.com with SMTP id r24-v6so4973098wmh.0
 for <linux-nvdimm@lists.01.org>; Tue, 24 Jul 2018 00:40:03 -0700 (PDT)
Date: Tue, 24 Jul 2018 09:39:58 +0200
From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH v6 00/13] mm: Teach memory_failure() about ZONE_DEVICE
 pages
Message-ID: <20180724073958.GB15984@gmail.com>
References: <153154376846.34503.15480221419473501643.stgit@dwillia2-desk3.amr.corp.intel.com>
 <b9602b1b-97d3-b9c1-cc85-5b73b67e2e03@intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <b9602b1b-97d3-b9c1-cc85-5b73b67e2e03@intel.com>
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
To: Dave Jiang <dave.jiang@intel.com>
Cc: Tony Luck <tony.luck@intel.com>, Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, Thomas Gleixner <tglx@linutronix.de>, linux-nvdimm@lists.01.org, x86@kernel.org, Michal Hocko <mhocko@suse.com>, linux-kernel@vger.kernel.org, stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Matthew Wilcox <willy@infradead.org>, linux-mm@kvack.org, =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Souptick Joarder <jrdr.linux@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>, linux-fsdevel@vger.kernel.org, Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, linux-edac@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>


* Dave Jiang <dave.jiang@intel.com> wrote:

> Ingo,
> Is it possible to ack the x86 bits in this patch series? I'm hoping to
> get this pulled through the libnvdimm tree for 4.19. Thanks!

With the minor typo fixed in the first patch, both patches are looking good to me:

  Acked-by: Ingo Molnar <mingo@kernel.org>

Assuming that it gets properly tested, etc.

Thanks,

	Ingo
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
