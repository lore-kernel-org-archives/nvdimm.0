Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot0-x244.google.com (mail-ot0-x244.google.com
 [IPv6:2607:f8b0:4003:c0f::244])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 27202209574EB
 for <linux-nvdimm@lists.01.org>; Mon, 26 Feb 2018 12:34:59 -0800 (PST)
Received: by mail-ot0-x244.google.com with SMTP id n74so1654179ota.1
 for <linux-nvdimm@lists.01.org>; Mon, 26 Feb 2018 12:41:05 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <6a5a6353-2714-8eb6-2566-a4384a95db0b@netapp.com>
References: <6a5a6353-2714-8eb6-2566-a4384a95db0b@netapp.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 26 Feb 2018 12:41:03 -0800
Message-ID: <CAPcyv4g12j84_qNAdz2nMt0-GU=uMfk2ryHwYZFKGEiqZbkgsg@mail.gmail.com>
Subject: Re: [PATCH] dax: ->direct_access does not sleep anymore
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
To: Boaz Harrosh <boazh@netapp.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Feb 26, 2018 at 8:50 AM, Boaz Harrosh <boazh@netapp.com> wrote:
>
> In Patch:
>         [7a862fb] brd: remove dax support
>
>   Dan Williams has removed the only might_sleep
>   implementation of ->direct_access.
>   So we no longer need to check for it.
>
> CC: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Boaz Harrosh <boazh@netapp.com>

Looks good, applied.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
