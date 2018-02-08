Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6B93922361E4C
 for <linux-nvdimm@lists.01.org>; Thu,  8 Feb 2018 13:02:20 -0800 (PST)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [PATCH v3] libnvdimm, testing: Add emulation for smart
 injection commands
Date: Thu, 8 Feb 2018 21:08:04 +0000
Message-ID: <1518124082.8128.53.camel@intel.com>
References: <20180208204956.4821-1-vishal.l.verma@intel.com>
 <CAPcyv4jrtkoXH+pH1xDPatickpMpQLJqUciig1XaD=hqBw6u8Q@mail.gmail.com>
In-Reply-To: <CAPcyv4jrtkoXH+pH1xDPatickpMpQLJqUciig1XaD=hqBw6u8Q@mail.gmail.com>
Content-Language: en-US
Content-ID: <6B06700D24295845B5C0B03AF9873B51@intel.com>
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
To: "Williams, Dan J" <dan.j.williams@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>


On Thu, 2018-02-08 at 12:54 -0800, Dan Williams wrote:
> On Thu, Feb 8, 2018 at 12:49 PM, Vishal Verma <vishal.l.verma@intel.c
> om> wrote:
> > Add support for the smart injection command in the nvdimm unit test
> > framework. This allows for directly injecting to smart fields and
> > flags
> > that are supported in the injection command. If the injected values
> > are
> > past the threshold, then an acpi notification is also triggered.
> > 
> > Also update the default smart ctrl_temperature to start out below
> > the
> > default threshold instead of at it. This prevents arbitrary smart
> > injections from triggering an acpi notification
> 
> Any sentence starting with "Also" in a changelog is almost always an
> indication to split the patch in 2 so the topics can be independently
> bisected.

True, I did read that advice somewhere, but I figured these are related
enough that they can go together. But I agree separating them for
bisectability can be useful, I'll send a new revision
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
