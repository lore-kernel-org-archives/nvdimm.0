Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7EF0E211B76DB
 for <linux-nvdimm@lists.01.org>; Tue, 15 Jan 2019 14:53:44 -0800 (PST)
From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH v3 0/2] acpi/nfit: Fix command-supported detection
References: <154759163682.1953028.16995572958827750312.stgit@dwillia2-desk3.amr.corp.intel.com>
Date: Tue, 15 Jan 2019 17:53:42 -0500
In-Reply-To: <154759163682.1953028.16995572958827750312.stgit@dwillia2-desk3.amr.corp.intel.com>
 (Dan Williams's message of "Tue, 15 Jan 2019 14:33:56 -0800")
Message-ID: <x495zup7csp.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
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
Cc: linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org, Sujith Pandel <sujith_pandel@dell.com>, stuart hayes <stuart.w.hayes@gmail.com>
List-ID: <linux-nvdimm@lists.01.org>

Dan Williams <dan.j.williams@intel.com> writes:

> Changes since v2 [1]:
> * Don't allow ND_CMD_CALL to bypass dsm_mask restrictions (Jeff)
>
> [1]: https://lists.01.org/pipermail/linux-nvdimm/2019-January/019498.html
>
> ---
>
> One last resend to make sure all the last bits of thrash have settled.

LGTM.

Thanks!
Jeff
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
