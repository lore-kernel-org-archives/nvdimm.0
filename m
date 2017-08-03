Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ua0-x22a.google.com (mail-ua0-x22a.google.com
 [IPv6:2607:f8b0:400c:c08::22a])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 21F7721C9127B
 for <linux-nvdimm@lists.01.org>; Thu,  3 Aug 2017 15:25:18 -0700 (PDT)
Received: by mail-ua0-x22a.google.com with SMTP id w45so143130uac.5
 for <linux-nvdimm@lists.01.org>; Thu, 03 Aug 2017 15:27:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170803211835.18988-1-vishal.l.verma@intel.com>
References: <20170803211835.18988-1-vishal.l.verma@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 3 Aug 2017 15:27:28 -0700
Message-ID: <CAPcyv4hmo7tc_O5psyuNk0VrRHp4uwCPVVcGMq9kfR4q7THmnw@mail.gmail.com>
Subject: Re: [PATCH] ndctl, util: in util_namespace_to_json, initialize
 bb_count to 0
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
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Aug 3, 2017 at 2:18 PM, Vishal Verma <vishal.l.verma@intel.com> wrote:
> If in the util_namespace_to_json -> dev_badblocks_to_json call chain, if
> anything errors out before setting bb_count, bb_count will have an
> uninitialized, random value.
>
> This happens during namespace creation, as the namespaceX.Y/resource is
> not available (as the namespace is disabled), and the various
> util_<mode>_badblocks_to_json helpers fail due to a missing resource.
>
> $ ndctl create-namespace --type=pmem --mode=sector
> {
>   "dev":"namespace7.0",
>   "mode":"sector",
>   "size":"62.91 MiB (65.97 MB)",
>   "uuid":"ca26fe8e-3f9a-4e3f-bfb0-1e34714996a4",
>   "sector_size":4096,
>   "blockdev":"pmem7s",
>   "badblock_count":22
> }
>
> $ ndctl list --namespace=namespace7.0
> {
>   "dev":"namespace7.0",
>   "mode":"sector",
>   "size":65966080,
>   "uuid":"ca26fe8e-3f9a-4e3f-bfb0-1e34714996a4",
>   "sector_size":4096,
>   "blockdev":"pmem7s",
>   "badblock_count":8
> }
>
> Fix this by initializing bb_count to 0.
>
> Cc: Dave Jiang <dave.jiang@intel.com>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>

Looks good to me, applied.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
