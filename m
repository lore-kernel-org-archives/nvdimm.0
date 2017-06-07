Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x22d.google.com (mail-oi0-x22d.google.com
 [IPv6:2607:f8b0:4003:c06::22d])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 23F6321AE30D1
 for <linux-nvdimm@lists.01.org>; Wed,  7 Jun 2017 14:13:07 -0700 (PDT)
Received: by mail-oi0-x22d.google.com with SMTP id o65so11001710oif.1
 for <linux-nvdimm@lists.01.org>; Wed, 07 Jun 2017 14:14:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <149686923837.13885.5048755294647675245.stgit@djiang5-desk3.ch.intel.com>
References: <149686923837.13885.5048755294647675245.stgit@djiang5-desk3.ch.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 7 Jun 2017 14:14:14 -0700
Message-ID: <CAPcyv4j2gp12k0ARqhFzWv-Dom+HUM+7T8vgYFnEmcrXe=Dczg@mail.gmail.com>
Subject: Re: [PATCH] ndctl: fix uninitialized bb_count in list command
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
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Jun 7, 2017 at 2:00 PM, Dave Jiang <dave.jiang@intel.com> wrote:
> bb_count would be 0 if util_region_badblocks_to_json() returns NULL.
> Initialize bb_count to 0 by default.
>
> Reported-by: Andy Rudoff <andy.rudoff@intel.com>
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>

Thanks Dave! Applied and pushed out on the 'pending' branch.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
