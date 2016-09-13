Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-wm0-x244.google.com (mail-wm0-x244.google.com
 [IPv6:2a00:1450:400c:c09::244])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E52F71A1E48
 for <linux-nvdimm@lists.01.org>; Tue, 13 Sep 2016 11:44:51 -0700 (PDT)
Received: by mail-wm0-x244.google.com with SMTP id g141so8593173wmd.1
 for <linux-nvdimm@lists.01.org>; Tue, 13 Sep 2016 11:44:51 -0700 (PDT)
Date: Tue, 13 Sep 2016 20:44:46 +0200
From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [RFC PATCH 2/2] x86: wire up mincore2()
Message-ID: <20160913184445.GA810@gmail.com>
References: <147361509579.17004.5258725187329709824.stgit@dwillia2-desk3.amr.corp.intel.com>
 <147361510160.17004.6974628969361614698.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <147361510160.17004.6974628969361614698.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: linux-nvdimm@lists.01.org, linux-api@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
List-ID: <linux-nvdimm@lists.01.org>


* Dan Williams <dan.j.williams@intel.com> wrote:

> Add the new the mincore2() symbol to the x86 syscall tables.

Could you please send the patch against -tip? We have this (new) commit in the x86 
tree:

  f9afc6197e9b x86: Wire up protection keys system calls

... which created a new conflict.

Thanks,

	Ingo
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
