Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com
 [IPv6:2607:f8b0:4864:20::341])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9E9F321161B05
 for <linux-nvdimm@lists.01.org>; Tue,  2 Oct 2018 18:58:44 -0700 (PDT)
Received: by mail-ot1-x341.google.com with SMTP id m23-v6so4012550otf.0
 for <linux-nvdimm@lists.01.org>; Tue, 02 Oct 2018 18:58:44 -0700 (PDT)
MIME-Version: 1.0
References: <20181002033140.21295-1-vishal.l.verma@intel.com>
 <20181002033140.21295-5-vishal.l.verma@intel.com>
In-Reply-To: <20181002033140.21295-5-vishal.l.verma@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 2 Oct 2018 18:58:32 -0700
Message-ID: <CAPcyv4hkoWbKXT7HcM6AhOkE-u6QEKoS6ppdrqJUcB2b8yjoTQ@mail.gmail.com>
Subject: Re: [ndctl PATCH 5/5] util/json: add a
 util_namespace_badblocks_to_json() helper
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
To: Vishal L Verma <vishal.l.verma@intel.com>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Oct 1, 2018 at 8:38 PM Vishal Verma <vishal.l.verma@intel.com> wrote:
>
> When ndctl list --media-errors is invoked, we rely upon the 'region'
> badblocks provided by the kernel, and reference them against the
> namespace start to report namespace badblocks. This can fail for
> non-root users, as the region and namespace resource information is
> root-only. However the kernel also provides block-device badblocks
> information in sysfs, and that is world readable. Provide a new helper
> to retrieve this information, and use it as a fallback when the region
> based badblocks are unavailable.
>
> Note that when falling back to the namespace based badblocks, we are
> unable to retrieve the DIMM on which the badblocks are present, since we
> still need root privileges for both getting the resource information,
> and for the address translation command.
>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
