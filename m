Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi1-x22f.google.com (mail-oi1-x22f.google.com
 [IPv6:2607:f8b0:4864:20::22f])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B635D211A7565
 for <linux-nvdimm@lists.01.org>; Fri, 11 Jan 2019 17:54:23 -0800 (PST)
Received: by mail-oi1-x22f.google.com with SMTP id y23so13791989oia.4
 for <linux-nvdimm@lists.01.org>; Fri, 11 Jan 2019 17:54:23 -0800 (PST)
MIME-Version: 1.0
References: <20190112013035.32087-1-vishal.l.verma@intel.com>
 <20190112013035.32087-4-vishal.l.verma@intel.com>
In-Reply-To: <20190112013035.32087-4-vishal.l.verma@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 11 Jan 2019 17:54:12 -0800
Message-ID: <CAPcyv4higwi3zVBwQLPgxQ1QN68xf4=dy9E0rZDens_PbsW4Fw@mail.gmail.com>
Subject: Re: [ndctl PATCH v2 3/4] ndctl,
 monitor: switch to ndctl_cmd_submit_xlat
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
Cc: Ami Pathak <ami.g.pathak@intel.com>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Jan 11, 2019 at 5:31 PM Vishal Verma <vishal.l.verma@intel.com> wrote:
>
> The ndctl monitor command was neglecting to check the 'firmware_status'
> field that is set by the platform firmware to indicate failure. Use
> the new ndctl_cmd_submit_xlat facility to include the firmware_status
> check as part of the command submission.
>
> Cc: QI Fuli <qi.fuli@jp.fujitsu.com>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>

Looks good,

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
