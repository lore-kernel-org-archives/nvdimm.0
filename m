Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx141.netapp.com (mx141.netapp.com
 [IPv6:2620:10a:4005:8000:2306::a])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 71CB4203B8CC1
 for <linux-nvdimm@lists.01.org>; Wed, 16 May 2018 07:06:49 -0700 (PDT)
From: "Korman, Yigal" <Yigal.Korman@netapp.com>
Subject: RE: ndctl create-namespace '--map' option
Date: Wed, 16 May 2018 14:06:46 +0000
Message-ID: <MWHPR0601MB36769591DA5BA7C7B7CB74A7EB920@MWHPR0601MB3676.namprd06.prod.outlook.com>
References: <MWHPR0601MB36767B701B207CC71A40AC3CEB920@MWHPR0601MB3676.namprd06.prod.outlook.com>
 <CAPcyv4gc=UeG2gm=pVKp9wwfSx5oCxPwsdHrTPM_BZ2j+S9gHw@mail.gmail.com>
In-Reply-To: <CAPcyv4gc=UeG2gm=pVKp9wwfSx5oCxPwsdHrTPM_BZ2j+S9gHw@mail.gmail.com>
Content-Language: en-US
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
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>



> -----Original Message-----
> From: Dan Williams <dan.j.williams@intel.com>
> Sent: Wednesday, May 16, 2018 5:03 PM
> To: Korman, Yigal <Yigal.Korman@netapp.com>
> Cc: linux-nvdimm@lists.01.org
> Subject: Re: ndctl create-namespace '--map' option
> 
> On Wed, May 16, 2018 at 12:47 AM, Korman, Yigal
> <Yigal.Korman@netapp.com> wrote:
> > Hi Dan,
> > I was wandering why there's no way of checking where an existing namespace
> keeps its page-structs (AKA --map={mem,dev})?
> > 'ndctl list --namespaces' doesn't seem to show this.
> > Is this intentional? Or just a missing feature?
> 
> I originally assumed it was too much detail. However, given this request and the
> discussion around always showing "sector_size" we should add this property to
> the output. I'll throw this task on the dev queue.

Thanks, much appreciated.
Y
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
