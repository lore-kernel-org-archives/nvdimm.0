Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x332.google.com (mail-ot1-x332.google.com
 [IPv6:2607:f8b0:4864:20::332])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2222321161B03
 for <linux-nvdimm@lists.01.org>; Tue,  2 Oct 2018 18:48:08 -0700 (PDT)
Received: by mail-ot1-x332.google.com with SMTP id u22so3934814ota.12
 for <linux-nvdimm@lists.01.org>; Tue, 02 Oct 2018 18:48:08 -0700 (PDT)
MIME-Version: 1.0
References: <20181002033140.21295-1-vishal.l.verma@intel.com>
 <20181002033140.21295-3-vishal.l.verma@intel.com>
In-Reply-To: <20181002033140.21295-3-vishal.l.verma@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 2 Oct 2018 18:47:56 -0700
Message-ID: <CAPcyv4jQCaQr4AR2mxX8zfpF_NGSpRidDPgk=RHfxbjwerH9OQ@mail.gmail.com>
Subject: Re: [ndctl PATCH 3/5] util/json: fix an error check for region
 resource
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
> The return type of ndctl_region_get_resource() is 'unsigned long long',
> and therefore the error checking for it should be done against
> ULLONG_MAX. Fix an instance where we were checking against ULONG_MAX.
>

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
