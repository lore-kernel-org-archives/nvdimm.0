Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 61FB221219AF7
 for <linux-nvdimm@lists.01.org>; Tue, 23 Apr 2019 06:24:45 -0700 (PDT)
Date: Tue, 23 Apr 2019 09:24:43 -0400
From: Sasha Levin <sashal@kernel.org>
Subject: Re: [4.19, 5.0 stable PATCH 1/4] nfit/ars: Remove ars_start_flags
Message-ID: <20190423132443.GJ17719@sasha-vm>
References: <155597449036.2675082.7035380482732870260.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <155597449036.2675082.7035380482732870260.stgit@dwillia2-desk3.amr.corp.intel.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Dan Williams <dan.j.williams@intel.com>
Cc: stable@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Apr 22, 2019 at 04:08:10PM -0700, Dan Williams wrote:
>commit 317a992ab9266b86b774b9f6b0f87eb4f59879a1 upstream.
>
>The ars_start_flags property of 'struct acpi_nfit_desc' is no longer
>used since ARS_REQ_SHORT and ARS_REQ_LONG were added.
>
>Reviewed-by: Toshi Kani <toshi.kani@hpe.com>
>Signed-off-by: Dan Williams <dan.j.williams@intel.com>

I've queued this series for both 4.19 and 5.0, thanks!

--
Thanks,
Sasha
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
