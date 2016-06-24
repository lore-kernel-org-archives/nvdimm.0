Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x229.google.com (mail-oi0-x229.google.com
 [IPv6:2607:f8b0:4003:c06::229])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 857E71A1E16
 for <linux-nvdimm@lists.01.org>; Fri, 24 Jun 2016 08:41:25 -0700 (PDT)
Received: by mail-oi0-x229.google.com with SMTP id u201so120221726oie.0
 for <linux-nvdimm@lists.01.org>; Fri, 24 Jun 2016 08:40:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1466764164-69726-1-git-send-email-jthumshirn@suse.de>
References: <1466764164-69726-1-git-send-email-jthumshirn@suse.de>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 24 Jun 2016 08:40:49 -0700
Message-ID: <CAPcyv4gqO1qP59c3qaUMsOdseJaa4iLBqXsNMS3f_7a5hvO0OA@mail.gmail.com>
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
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Jun 24, 2016 at 3:29 AM, Johannes Thumshirn <jthumshirn@suse.de> wrote:
> User module_platform_driver macro instead of open-coding it.
>
> Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>

Looks good.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
