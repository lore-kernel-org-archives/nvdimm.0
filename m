Return-Path: <linux-kernel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <1429644912.17259.31.camel@misato.fc.hp.com>
References: <20150418013256.25237.96403.stgit@dwillia2-desk3.amr.corp.intel.com>
	<20150418013535.25237.4770.stgit@dwillia2-desk3.amr.corp.intel.com>
	<1429644912.17259.31.camel@misato.fc.hp.com>
Date: Tue, 21 Apr 2015 12:58:22 -0700
Message-ID: <CAPcyv4iHHRUg4q2cT0MHQGx1VV=F8qh3bbBvU_CXr7wuO0Ccww@mail.gmail.com>
Subject: Re: [Linux-nvdimm] [PATCH 04/21] nd: create an 'nd_bus' from an 'nfit_desc'
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
To: Toshi Kani <toshi.kani@hp.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Apr 21, 2015 at 12:35 PM, Toshi Kani <toshi.kani@hp.com> wrote:
> On Fri, 2015-04-17 at 21:35 -0400, Dan Williams wrote:
>  :
>> +
>> +static int nd_mem_init(struct nd_bus *nd_bus)
>> +{
>> +     struct nd_spa *nd_spa;
>> +
>> +     /*
>> +      * For each SPA-DCR address range find its corresponding
>> +      * MEMDEV(s).  From each MEMDEV find the corresponding DCR.
>> +      * Then, try to find a SPA-BDW and a corresponding BDW that
>> +      * references the DCR.  Throw it all into an nd_mem object.
>> +      * Note, that BDWs are optional.
>> +      */
>> +     list_for_each_entry(nd_spa, &nd_bus->spas, list) {
>> +             u16 spa_index = readw(&nd_spa->nfit_spa->spa_index);
>> +             int type = nfit_spa_type(nd_spa->nfit_spa);
>> +             struct nd_mem *nd_mem, *found;
>> +             struct nd_memdev *nd_memdev;
>> +             u16 dcr_index;
>> +
>> +             if (type != NFIT_SPA_DCR)
>> +                     continue;
>
> This function requires NFIT_SPA_DCR, SPA Range Structure with NVDIMM
> Control Region GUID, for initializing an nd_mem object.  However,
> battery-backed DIMMs do not have such control region SPA.  IIUC, the
> NFIT spec does not require NFIT_SPA_DCR.
>
> Can you change this function to work with NFIT_SPA_PM as well?

NFIT_SPA_PM ranges are handled separately from nd_mem_init().  See
nd_region_create() in patch 10.
