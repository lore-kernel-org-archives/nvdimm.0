Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x329.google.com (mail-ot1-x329.google.com
 [IPv6:2607:f8b0:4864:20::329])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7E2302116DF8A
 for <linux-nvdimm@lists.01.org>; Fri, 12 Oct 2018 12:24:07 -0700 (PDT)
Received: by mail-ot1-x329.google.com with SMTP id l58so13404120otd.6
 for <linux-nvdimm@lists.01.org>; Fri, 12 Oct 2018 12:24:07 -0700 (PDT)
MIME-Version: 1.0
References: <153936863308.55836.2972520178944977338.stgit@djiang5-desk3.ch.intel.com>
 <153936864380.55836.1354884792663339045.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <153936864380.55836.1354884792663339045.stgit@djiang5-desk3.ch.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 12 Oct 2018 12:23:55 -0700
Message-ID: <CAPcyv4jP=YQ41VV4sFAuno4Ec-FBc3c0qcv7g_qXmcaA0OXFig@mail.gmail.com>
Subject: Re: [PATCH 3/5] libnvdimm: remove driver attached check for secure
 erase
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
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Oct 12, 2018 at 11:24 AM Dave Jiang <dave.jiang@intel.com> wrote:
>
> We should be able to do secure erase when dimm is idle but not disabled.
> Remove check for driver attachment.
>
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>

Yup, looks good.

Since there's no dependency on the other patches in this series I'll
just go ahead and apply this.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
