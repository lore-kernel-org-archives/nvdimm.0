Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x233.google.com (mail-oi0-x233.google.com
 [IPv6:2607:f8b0:4003:c06::233])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 57003203B85BA
 for <linux-nvdimm@lists.01.org>; Wed, 16 May 2018 07:03:11 -0700 (PDT)
Received: by mail-oi0-x233.google.com with SMTP id v2-v6so802984oif.3
 for <linux-nvdimm@lists.01.org>; Wed, 16 May 2018 07:03:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <MWHPR0601MB36767B701B207CC71A40AC3CEB920@MWHPR0601MB3676.namprd06.prod.outlook.com>
References: <MWHPR0601MB36767B701B207CC71A40AC3CEB920@MWHPR0601MB3676.namprd06.prod.outlook.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 16 May 2018 07:03:10 -0700
Message-ID: <CAPcyv4gc=UeG2gm=pVKp9wwfSx5oCxPwsdHrTPM_BZ2j+S9gHw@mail.gmail.com>
Subject: Re: ndctl create-namespace '--map' option
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
To: "Korman, Yigal" <Yigal.Korman@netapp.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, May 16, 2018 at 12:47 AM, Korman, Yigal <Yigal.Korman@netapp.com> wrote:
> Hi Dan,
> I was wandering why there's no way of checking where an existing namespace keeps its page-structs (AKA --map={mem,dev})?
> 'ndctl list --namespaces' doesn't seem to show this.
> Is this intentional? Or just a missing feature?

I originally assumed it was too much detail. However, given this
request and the discussion around always showing "sector_size" we
should add this property to the output. I'll throw this task on the
dev queue.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
