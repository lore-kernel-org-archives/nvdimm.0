Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x234.google.com (mail-oi0-x234.google.com
 [IPv6:2607:f8b0:4003:c06::234])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id BF87C81CC6
 for <linux-nvdimm@lists.01.org>; Sun, 30 Oct 2016 08:50:22 -0700 (PDT)
Received: by mail-oi0-x234.google.com with SMTP id 62so57980324oif.1
 for <linux-nvdimm@lists.01.org>; Sun, 30 Oct 2016 08:50:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20161029112852.19975-1-nicolas.iooss_linux@m4x.org>
References: <20161029112852.19975-1-nicolas.iooss_linux@m4x.org>
From: Dan Williams <dan.j.williams@intel.com>
Date: Sun, 30 Oct 2016 08:50:22 -0700
Message-ID: <CAPcyv4hwQQsZg-FG0h1yH-h4OsAe_Nd=-1=L9f-Zev2vUSHj2w@mail.gmail.com>
Subject: Re: [PATCH 1/1] nvdimm: use the right length of "pmem"
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
To: Nicolas Iooss <nicolas.iooss_linux@m4x.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Sat, Oct 29, 2016 at 4:28 AM, Nicolas Iooss
<nicolas.iooss_linux@m4x.org> wrote:
> In order to test that the name of a resource begins with "pmem", call
> strncmp() with 4 as length instead of 3 to match the whole prefix.
>
> Fixes: 16660eaea0cc ("libnvdimm, namespace: update label implementation
> for multi-pmem")
> Signed-off-by: Nicolas Iooss <nicolas.iooss_linux@m4x.org>

Thanks, although I would not call this out as a fix since the length
parameter could be 1 and still do the right thing.  I.e. we're
distinguishing "blk" from "pmem" resources.  I'll add this for 4.10 as
a cleanup.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
