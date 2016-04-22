Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ob0-x234.google.com (mail-ob0-x234.google.com
 [IPv6:2607:f8b0:4003:c01::234])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7EF5B1A21EA
 for <linux-nvdimm@lists.01.org>; Fri, 22 Apr 2016 16:33:03 -0700 (PDT)
Received: by mail-ob0-x234.google.com with SMTP id bg3so56477049obb.1
 for <linux-nvdimm@lists.01.org>; Fri, 22 Apr 2016 16:33:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160422231506.GB126763@tevye.fc.hp.com>
References: <cover.1460936121.git.jerry.hoemann@hpe.com>
 <9f04df3b80c68dd6406cfee5ce11a2cd8ed33b64.1460936121.git.jerry.hoemann@hpe.com>
 <CAPcyv4jiaoYnMi60ThWyeKVxj-3cWfd6ZgZq9Ot4Qfe4gXmvUQ@mail.gmail.com>
 <20160420174105.GC29474@tevye.fc.hp.com>
 <CAPcyv4iqcaaB+S-1ZMqq+nFCNsiWgs0K8hRCEoTqOzhTnA5vVA@mail.gmail.com>
 <20160421165235.GA115325@tevye.fc.hp.com>
 <CAPcyv4j5FVQY+QVgS640RFFG1vn9UidG0F9DcayoYNSTPqeE+Q@mail.gmail.com>
 <20160422231506.GB126763@tevye.fc.hp.com>
Date: Fri, 22 Apr 2016 16:33:02 -0700
Message-ID: <CAPcyv4jcuw-eh295JeD2Kh+qUg2UbHsvKY2ARuJ7Po5tKfMD5w@mail.gmail.com>
Subject: Re: [RFC v9 5/5] nvdimm: Add ioctl to return command mask.
From: Dan Williams <dan.j.williams@intel.com>
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
To: Jerry Hoemann <Jerry.Hoemann@hpe.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Apr 22, 2016 at 4:15 PM, Jerry Hoemann <jerry.hoemann@hpe.com> wrote:
> On Thu, Apr 21, 2016 at 11:18:40AM -0700, Dan Williams wrote:
[..]
>> Right, I don't want to add an ioctl for discovering dsm_mask.
>
> I can interpret your statement in multiple ways.
>
> We need to be able to call the query command (function 0) in pass thru
> to support our firmware.
>
> Now, if you're just saying you don't want to add
>
>
> +#define ND_IOCTL_CMD_MASK              _IOWR(ND_IOCTL, ND_CMD_IMPLEMENTED,\
> +                                       struct nd_cmd_mask)
>
>
> and other associated changes in ndctl.h, that is an entirely different
> and I can rework that patch.

So, I'm saying I don't want ND_CMD_CALL to be used to issue the "is
dsm function implemented?" check.  Especially because the kernel may
want to limit the mask for one reason or another, the raw data
returned from the DSM may not be accurate.  It also just comes across
as inefficient to me when the kernel has already probed this
information and is maintaining it internally.

Lastly ioctls are terrible and having one less piece of information
that is conveyed via an ioctl in favor of a sysfs attribute is a win.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
