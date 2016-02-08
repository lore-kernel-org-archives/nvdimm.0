Return-Path: <linux-kernel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <56B8F952.2080602@hpe.com>
References: <20160208183052.27820.68922.stgit@dwillia2-desk3.amr.corp.intel.com>
	<20160208183058.27820.87950.stgit@dwillia2-desk3.amr.corp.intel.com>
	<56B8E842.9080506@hpe.com>
	<56B8F952.2080602@hpe.com>
Date: Mon, 8 Feb 2016 12:37:44 -0800
Message-ID: <CAPcyv4idTuES6r1caUb2P8tWKp1RWU-ouG_Pime55cRn_Qkkyg@mail.gmail.com>
Subject: Re: [PATCH 1/3] nfit: fix multi-interface dimm handling, acpi6.1 compatibility
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
To: Linda Knippers <linda.knippers@hpe.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Linux ACPI <linux-acpi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Feb 8, 2016 at 12:23 PM, Linda Knippers <linda.knippers@hpe.com> wrote:
> On 2/8/2016 2:10 PM, Linda Knippers wrote:
>> On 2/8/2016 1:30 PM, Dan Williams wrote:
>>> ACPI 6.1 clarified that multi-interface dimms require multiple control
>>> region entries (DCRs) per dimm.  Previously we were assuming that a
>>> control region is only present when block-data-windows are present.
>>
>> We need to give this a quick test with NVDIMM-N because those types of
>> NVDIMMs have control regions without block-data-windows.  We've fixed
>> bugs related to that assumption a couple of times.
>
> I can't test the conditions for which these changes were made but the
> code continues to work on my NVDIMM-N system where we have control
> regions w/o block-data windows.
>

Nice, thanks for the test report!  For my part I verified that the
implementation passes the original plus the modified unit test as
updated in [PATCH 3/3].
