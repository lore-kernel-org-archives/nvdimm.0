Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x235.google.com (mail-oi0-x235.google.com
 [IPv6:2607:f8b0:4003:c06::235])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id BF32781FE6
 for <linux-nvdimm@lists.01.org>; Mon,  5 Dec 2016 09:01:47 -0800 (PST)
Received: by mail-oi0-x235.google.com with SMTP id w63so347507887oiw.0
 for <linux-nvdimm@lists.01.org>; Mon, 05 Dec 2016 09:01:47 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20161205082320.21777-1-jthumshirn@suse.de>
References: <20161205082320.21777-1-jthumshirn@suse.de>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 5 Dec 2016 09:01:46 -0800
Message-ID: <CAPcyv4hFM4zicu9iqCkRU_kJfixKmohG7uiz=mBoGwtfD4n9DQ@mail.gmail.com>
Subject: Re: [PATCH] e820: use module_platform_driver
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
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Linux NVDIMM Mailing List <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Dec 5, 2016 at 12:23 AM, Johannes Thumshirn <jthumshirn@suse.de> wrote:
> Use module_platform_driver for the e820 driver instead of open-coding it.
>
> Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>

Applied, thanks Johannes.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
