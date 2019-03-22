Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com
 [IPv6:2607:f8b0:4864:20::341])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0D310211E7441
 for <linux-nvdimm@lists.01.org>; Thu, 21 Mar 2019 23:11:59 -0700 (PDT)
Received: by mail-ot1-x341.google.com with SMTP id f10so982138otb.6
 for <linux-nvdimm@lists.01.org>; Thu, 21 Mar 2019 23:11:59 -0700 (PDT)
MIME-Version: 1.0
References: <PU1P153MB01691E80896E9EAA0C8245EDBF7D0@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
 <9876fd8a491e339f2f41a47e2195d354bf0d5fb2.camel@intel.com>
 <PU1P153MB0169CA436F52268DD2BEF745BF430@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
 <PU1P153MB0169F3CEDB7C2F4965450BB6BF430@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
 <CAPcyv4hVZLW2OSMZ9NqqsQWMg7vxyS9J1ekDZW8G44cmD9_YCw@mail.gmail.com>
 <PU1P153MB0169A7A65DB3A54040DE291ABF430@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
 <CAPcyv4hM_DTcMJdWhWbtPFfVH_V-kYxXSSCg=MQZLoxVka=Mng@mail.gmail.com>
 <PU1P153MB01696DB78FF62FAE07473594BF430@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
In-Reply-To: <PU1P153MB01696DB78FF62FAE07473594BF430@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 21 Mar 2019 23:11:46 -0700
Message-ID: <CAPcyv4h4tAydacTbmZRKy7hmTqWTM22r6hD+Ucm_f3H2tQUm3g@mail.gmail.com>
Subject: Re: [ndctl PATCH v2 4/4] ndctl, monitor: support NVDIMM_FAMILY_HYPERV
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
To: Dexuan Cui <decui@microsoft.com>
Cc: "qi.fuli@fujitsu.com" <qi.fuli@fujitsu.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Michael Kelley <mikelley@microsoft.com>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Mar 21, 2019 at 11:03 PM Dexuan Cui <decui@microsoft.com> wrote:
>
> > From: Dan Williams <dan.j.williams@intel.com>
> > Sent: Thursday, March 21, 2019 10:37 PM
> >
> > No, I think you misunderstand. Hyper-V implements "function-1",
> > "command-1" support can be emulated. The request is to translate the
> > Hyper-V function-1 payload into the command-1 payload format.
>
> Then, yes, I think so. The first 2 patches of this patchset do the translation:
>
> [ndctl,v2,1/4] libndctl: add support for NVDIMM_FAMILY_HYPERV's _DSM Function 1
> [ndctl,v2,2/4] libndctl: NVDIMM_FAMILY_HYPERV: add .smart_get_shutdown_count (Function 2)
> (https://patchwork.kernel.org/project/linux-nvdimm/list/?series=82629)
>
> The problem is how to skip the checkings in ndctl/monitor.c: filter_dimm() on Hyper-V.
> If we return early in filter_dimm(), mfa->num_dimm will be zero, then monitor_event()
> can't be called, and we have no chance to monitor the events and do the translation.

I'd rather change ndctl_dimm_cmd_is_supported() to call back into a
dimm-op so that the Hyper-V implementation can say "yes, I support
(emulate) the necessary monitor commands".
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
