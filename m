Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A4656211BA456
 for <linux-nvdimm@lists.01.org>; Fri, 25 Jan 2019 11:08:29 -0800 (PST)
Date: Fri, 25 Jan 2019 14:08:22 -0500
From: Jerome Glisse <jglisse@redhat.com>
Subject: Re: [PATCH 0/5] [v4] Allow persistent memory to be used like normal
 RAM
Message-ID: <20190125190820.GC3237@redhat.com>
References: <20190124231441.37A4A305@viggo.jf.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20190124231441.37A4A305@viggo.jf.intel.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Dave Hansen <dave.hansen@linux.intel.com>
Cc: thomas.lendacky@amd.com, mhocko@suse.com, linux-nvdimm@lists.01.org, tiwai@suse.de, ying.huang@intel.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, bp@suse.de, baiyaowei@cmss.chinamobile.com, zwisler@kernel.org, bhelgaas@google.com, fengguang.wu@intel.com, akpm@linux-foundation.org
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Jan 24, 2019 at 03:14:41PM -0800, Dave Hansen wrote:
> v3 spurred a bunch of really good discussion.  Thanks to everybody
> that made comments and suggestions!
> =

> I would still love some Acks on this from the folks on cc, even if it
> is on just the patch touching your area.
> =

> Note: these are based on commit d2f33c19644 in:
> =

> 	git://git.kernel.org/pub/scm/linux/kernel/git/djbw/nvdimm.git libnvdimm-=
pending
> =

> Changes since v3:
>  * Move HMM-related resource warning instead of removing it
>  * Use __request_resource() directly instead of devm.
>  * Create a separate DAX_PMEM Kconfig option, complete with help text
>  * Update patch descriptions and cover letter to give a better
>    overview of use-cases and hardware where this might be useful.

This one looks good to me, i will give it a go on monday to
test against nouveau and HMM.

Cheers,
J=E9r=F4me
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
