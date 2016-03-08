Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-wm0-x244.google.com (mail-wm0-x244.google.com
 [IPv6:2a00:1450:400c:c09::244])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 283671A1E91
 for <linux-nvdimm@lists.01.org>; Tue,  8 Mar 2016 09:33:25 -0800 (PST)
Received: by mail-wm0-x244.google.com with SMTP id l68so5431880wml.3
 for <linux-nvdimm@lists.01.org>; Tue, 08 Mar 2016 09:33:11 -0800 (PST)
Date: Tue, 8 Mar 2016 18:33:07 +0100
From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH v2-UPDATE2 3/4] resource: Add device-managed
 insert/remove_resource()
Message-ID: <20160308173307.GB3017@gmail.com>
References: <1457460530-17959-1-git-send-email-toshi.kani@hpe.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1457460530-17959-1-git-send-email-toshi.kani@hpe.com>
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
To: Toshi Kani <toshi.kani@hpe.com>
Cc: linux-nvdimm@lists.01.org, rjw@rjwysocki.net, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, bp@suse.de, akpm@linux-foundation.org
List-ID: <linux-nvdimm@lists.01.org>


* Toshi Kani <toshi.kani@hpe.com> wrote:

> insert_resource() and remove_resouce() are called by producers
> of resources, such as FW modules and bus drivers.  These modules
> may be implemented as loadable modules.
> 
> Add device-managed implementaions of insert_resource() and
> remove_resouce() functions.
> 
> Signed-off-by: Toshi Kani <toshi.kani@hpe.com>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Borislav Petkov <bp@suse.de>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Dan Williams <dan.j.williams@intel.com>

Acked-by: Ingo Molnar <mingo@kernel.org>

Thanks,

	Ingo
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
