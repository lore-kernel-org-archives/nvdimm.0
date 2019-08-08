Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C1BE5212E4B4C
 for <linux-nvdimm@lists.01.org>; Thu,  8 Aug 2019 13:23:28 -0700 (PDT)
From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [patch] nfit: report frozen security state
References: <x49k1bw7dqn.fsf@segfault.boston.devel.redhat.com>
 <CAPcyv4js-dZWFyRM7=JgC31uJUyxVzuwrderFrWf5p=z82E+WA@mail.gmail.com>
 <x49ef1whcjq.fsf@segfault.boston.devel.redhat.com>
 <CAPcyv4hUsbFP3=7RFLuHWWnZ+jkUfNFq9YRPKVGk22O7NuP8pA@mail.gmail.com>
Date: Thu, 08 Aug 2019 16:20:56 -0400
In-Reply-To: <CAPcyv4hUsbFP3=7RFLuHWWnZ+jkUfNFq9YRPKVGk22O7NuP8pA@mail.gmail.com>
 (Dan Williams's message of "Wed, 7 Aug 2019 15:27:35 -0700")
Message-ID: <x498ss3cst3.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

Dan Williams <dan.j.williams@intel.com> writes:

> ...but ABIs are forever, and ndctl has shipped:
>
>         if (strcmp(buf, "disabled") == 0)
>                 return NDCTL_SECURITY_DISABLED;
>         else if (strcmp(buf, "unlocked") == 0)
>                 return NDCTL_SECURITY_UNLOCKED;
>         else if (strcmp(buf, "locked") == 0)
>                 return NDCTL_SECURITY_LOCKED;
>         else if (strcmp(buf, "frozen") == 0)
>                 return NDCTL_SECURITY_FROZEN;
>         else if (strcmp(buf, "overwrite") == 0)
>                 return NDCTL_SECURITY_OVERWRITE;
>         return NDCTL_SECURITY_INVALID;
>
>
> I think we could break out the frozen state to its own new attribute
> and leave security state to only show "locked" / "unlocked". Then go
> teach new ndctl to go somewhere else to report frozen.

That works for me.

-Jeff
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
