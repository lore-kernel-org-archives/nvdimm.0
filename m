Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail1.bemta24.messagelabs.com (mail1.bemta24.messagelabs.com
 [67.219.250.113])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 87793211158EE
 for <linux-nvdimm@lists.01.org>; Tue,  4 Sep 2018 20:26:40 -0700 (PDT)
From: Ocean HY1 He <hehy1@lenovo.com>
Subject: RE: [External]  Re: [PATCH v2] libnvdimm, region_devs: stop
 NDD_ALIASING bit test if one test pass
Date: Wed, 5 Sep 2018 03:26:29 +0000
Message-ID: <HK0PR03MB317036BE69B40E73896A044189020@HK0PR03MB3170.apcprd03.prod.outlook.com>
References: <1536058062-18894-1-git-send-email-oceanhehy@gmail.com>
 <CAPcyv4iVYjbs_ds9tL4rceH5cSck=D-AkkejFh+rHXdY25nGfw@mail.gmail.com>
In-Reply-To: <CAPcyv4iVYjbs_ds9tL4rceH5cSck=D-AkkejFh+rHXdY25nGfw@mail.gmail.com>
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
To: Dan Williams <dan.j.williams@intel.com>, Ocean He <oceanhehy@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>



> -----Original Message-----
> From: Dan Williams <dan.j.williams@intel.com>
> Sent: Tuesday, September 04, 2018 11:58 PM
> To: Ocean He <oceanhehy@gmail.com>
> Cc: Ross Zwisler <ross.zwisler@linux.intel.com>; Vishal L Verma
> <vishal.l.verma@intel.com>; Dave Jiang <dave.jiang@intel.com>; linux-
> nvdimm <linux-nvdimm@lists.01.org>; Linux Kernel Mailing List <linux-
> kernel@vger.kernel.org>; Ocean HY1 He <hehy1@lenovo.com>
> Subject: [External] Re: [PATCH v2] libnvdimm, region_devs: stop
> NDD_ALIASING bit test if one test pass
> 
> On Tue, Sep 4, 2018 at 3:47 AM, Ocean He <oceanhehy@gmail.com> wrote:
> > From: Ocean He <hehy1@lenovo.com>
> >
> > There is no need to finish entire loop to execute NDD_ALIASING bit test
> > against every nvdimm->flags.
> 
> Of course there is. I see nothing stopping someone mixing an NVDIMM
> that supports labels with one that doesn't. 
Hi Dan,
Thanks for your comments.

I only have NVDIMM which supports label, so I could not do this type test yet.
As I understand your words, in mixing status, the nstype would be
ND_DEVICE_NAMESPACE_PMEM if one NVDIMM supports labels. Am I right?

By the way, do you think my patch is valuable to save a few cpu cycles here?

Ocean.
> If anything I think we
> need fixes to make sure this operates correctly to force disable
> BLK-mode capactiy when the PMEM capacity is interleaved with a
> label-less NVDIMM.
I am trying to translate your words to test steps, please correct me for
misunderstanding.
#1. Prepare 2 NVDIMMs which has no label capacity.
#2. Create a region which has PMEM capacity and interleaved.
ipmctl create -f -goal -socket 0x1 PersistentMemoryType=AppDirect
#3. Create a BLK-mode capacity namespace, then this namespace should be 
"force disable" ?
ndctl create-namespace -r region1 -s 1g -t pmem -m sector

Ocean.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
