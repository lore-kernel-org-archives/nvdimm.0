Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi1-x242.google.com (mail-oi1-x242.google.com
 [IPv6:2607:f8b0:4864:20::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 07BDC211A7565
 for <linux-nvdimm@lists.01.org>; Fri, 11 Jan 2019 17:53:55 -0800 (PST)
Received: by mail-oi1-x242.google.com with SMTP id v6so13789619oif.2
 for <linux-nvdimm@lists.01.org>; Fri, 11 Jan 2019 17:53:55 -0800 (PST)
MIME-Version: 1.0
References: <20190112013035.32087-1-vishal.l.verma@intel.com>
 <20190112013035.32087-5-vishal.l.verma@intel.com>
In-Reply-To: <20190112013035.32087-5-vishal.l.verma@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 11 Jan 2019 17:53:44 -0800
Message-ID: <CAPcyv4jKPJv4iVnDLw8V8EPXZfLFXBbtSMxTpQSfJURrqkxS_g@mail.gmail.com>
Subject: Re: [ndctl PATCH v2 4/4] ndctl: clean up usage of ndctl_cmd_submit
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
> It is possible for ndctl_cmd_submit to return a positive number,
> indicating a buffer underrun. It is only truly an error if it returns a
> negative number. Several places in the library, the ndctl utility, and
> in test/ were simply checking for an error with "if (rc)". Fix these to
> only error out for negative returns.
>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>

Looks good,

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
