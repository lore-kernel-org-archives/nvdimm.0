Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g9t5008.houston.hpe.com (g9t5008.houston.hpe.com [15.241.48.72])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0D9B221D0A260
 for <linux-nvdimm@lists.01.org>; Wed, 16 Aug 2017 13:10:31 -0700 (PDT)
Message-ID: <5994A73A.9000908@hpe.com>
Date: Wed, 16 Aug 2017 16:12:42 -0400
From: Linda Knippers <linda.knippers@hpe.com>
MIME-Version: 1.0
Subject: Re: don't control-c during ndctl create-namespace?
References: <556dc70b-2759-b483-868e-041f1be772f7@hpe.com>
 <x49inhna2lb.fsf@segfault.boston.devel.redhat.com>
In-Reply-To: <x49inhna2lb.fsf@segfault.boston.devel.redhat.com>
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
To: Jeff Moyer <jmoyer@redhat.com>, Dan Williams <dan.j.williams@intel.com>
Cc: "Saldivar, Maurice A." <maurice.a.saldivar@hpe.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On 08/16/2017 12:40 PM, Jeff Moyer wrote:
> Hi, Linda and Dan,
> 
> Linda Knippers <linda.knippers@hpe.com> writes:
> 
>> Hi Dan,
>>
>> I've got 4 NVDIMMs in an interleave set in a configuration that supports labels.
>> I'm running a 4.12 kernel with the latest ndctl.
>>
>> I had three namespaces configured and all seemed well.  When I configured the
>> fourth one, I made a mistake in the name so I hit control-c.  I wasn't sure what
>> state I was in but according to what I could see with ndctl, it had created the
>> namespace but not  enabled it, so I enabled it manually with ndctl and that
>> seemed ok.
>>
>> Then I tried to use ndctl create-namespace to change the name, which failed
>> because the namespace was enabled so I disabled it and tried again.  At some
>> point, not really sure where, I got this kernel warning:
>>
>> # [ 5224.196085] nd namespace4.3: failed to track label: 4
> 
> I think I know how to reproduce this part reliably.  Simply try to
> create multiple namespaces in a single region at the same time:
> 
> # ndctl create-namespace -r regionN -m memory & ndctl create-namespace -r regionN -m memory
> 
> That will lead to the dev_WARN_ONCE Linda mentioned.  Then, the DIMM
> will have an invalid label layout.  On reboot, the dimm will be disabled
> (these messages are printed when I reboot in this state):
> 
> [   24.311419] nvdimm nmem1: nvdimm_init_config_data: len: 131072 rc: 0
> [   24.311420] nvdimm nmem1: config data size: 131072
> [   24.311421] nvdimm nmem1: __nd_label_validate: nsindex0 labelsize 1 invalid
> [   24.311422] nvdimm nmem1: __nd_label_validate: nsindex1 labelsize 1 invalid
> [   24.311425] nvdimm nmem1: : pmem-9221e8a3: 0x1f80000000 @ 0x10000000 reserve
> [   24.311427] nvdimm nmem1: : null: 0x0 @ 0x0 reserve
> [   24.311428] nvdimm nmem1: nvdimm_drvdata_release
> [   24.311430] nd_bus ndbus0: nvdimm.probe(nmem1) = -16
> [   24.311442] nvdimm: probe of nmem1 failed with error -16
> 
> Trying to enable nmem1 will result in EBUSY, since we're trying to
> reserve address 0 (see the null entry above).
> 
> Unlike Linda's case, I can recover by zeroing the label space.  

If you have to zero your labels, it's not really recovering. Or are you
able to recreate labels and not lose data that might have been in those
pmem ranges?

> However, I don't have interleave enabled.

Perhaps Maurice can try this with interleave enabled.

-- ljk
> 
> I've attached the result of read-labels for nmem1 below.
> 
> -Jeff
> 
> # ndctl read-labels -j nmem1           
> {
>   "dev":"nmem1",
>   "index":[
>     {
>       "signature":"NAMESPACE_INDEX",
>       "major":1,
>       "minor":2,
>       "labelsize":256,
>       "seq":1,
>       "nslot":510
>     },
>     {
>       "signature":"NAMESPACE_INDEX",
>       "major":1,
>       "minor":2,
>       "labelsize":256,
>       "seq":2,
>       "nslot":510
>     }
>   ],
>   "label":[
>     {
>       "uuid":"9221e8a3-f43a-4204-86b1-e4bcd977ae27",
>       "name":"",
>       "slot":0,
>       "position":0,
>       "nlabel":1,
>       "isetcookie":62413126465469009,
>       "lbasize":0,
>       "dpa":268435456,
>       "rawsize":135291469824,
>       "type_guid":"79d3f066-f3b4-7440-ac43-0d3318b78cdb",
>       "abstraction_guid":"00000000-0000-0000-0000-000000000000"
>     },
>     {
>       "uuid":"4c812805-e736-4876-bab2-eab15a847a9f",
>       "name":"",
>       "slot":1,
>       "position":0,
>       "nlabel":1,
>       "isetcookie":62413126465469009,
>       "lbasize":0,
>       "dpa":268435456,
>       "rawsize":135291469824,
>       "type_guid":"79d3f066-f3b4-7440-ac43-0d3318b78cdb",
>       "abstraction_guid":"00000000-0000-0000-0000-000000000000"
>     },
>     {
>       "uuid":"4c812805-e736-4876-bab2-eab15a847a9f",
>       "name":"",
>       "slot":2,
>       "position":0,
>       "nlabel":1,
>       "isetcookie":62413126465469009,
>       "lbasize":0,
>       "dpa":268435456,
>       "rawsize":135291469824,
>       "type_guid":"79d3f066-f3b4-7440-ac43-0d3318b78cdb",
>       "abstraction_guid":"00000000-0000-0000-0000-000000000000"
>     },
>     {
>       "uuid":"f7be9e94-1ba7-4f52-9090-12bcc08839fb",
>       "name":"",
>       "slot":3,
>       "position":0,
>       "nlabel":1,
>       "isetcookie":62413126465469009,
>       "lbasize":0,
>       "dpa":268435456,
>       "rawsize":135291469824,
>       "type_guid":"79d3f066-f3b4-7440-ac43-0d3318b78cdb",
>       "abstraction_guid":"00000000-0000-0000-0000-000000000000"
>     },
>     {
>       "uuid":"f7be9e94-1ba7-4f52-9090-12bcc08839fb",
>       "name":"",
>       "slot":4,
>       "position":0,
>       "nlabel":1,
>       "isetcookie":62413126465469009,
>       "lbasize":0,
>       "dpa":268435456,
>       "rawsize":135291469824,
>       "type_guid":"79d3f066-f3b4-7440-ac43-0d3318b78cdb",
>       "abstraction_guid":"00000000-0000-0000-0000-000000000000"
>     },
>     {
>       "uuid":"f7be9e94-1ba7-4f52-9090-12bcc08839fb",
>       "name":"",
>       "slot":5,
>       "position":0,
>       "nlabel":1,
>       "isetcookie":62413126465469009,
>       "lbasize":0,
>       "dpa":268435456,
>       "rawsize":135291469824,
>       "type_guid":"79d3f066-f3b4-7440-ac43-0d3318b78cdb",
>       "abstraction_guid":"00000000-0000-0000-0000-000000000000"
>     },
>     {
>       "uuid":"b8bf5176-cc34-4b39-8d03-3a912e715366",
>       "name":"",
>       "slot":6,
>       "position":0,
>       "nlabel":1,
>       "isetcookie":62413126465469009,
>       "lbasize":0,
>       "dpa":268435456,
>       "rawsize":135291469824,
>       "type_guid":"79d3f066-f3b4-7440-ac43-0d3318b78cdb",
>       "abstraction_guid":"00000000-0000-0000-0000-000000000000"
>     },
>     {
>       "uuid":"bd340ce8-5774-402b-b1ac-b82d590665d7",
>       "name":"",
>       "slot":7,
>       "position":0,
>       "nlabel":1,
>       "isetcookie":62413126465469009,
>       "lbasize":0,
>       "dpa":268435456,
>       "rawsize":135291469824,
>       "type_guid":"79d3f066-f3b4-7440-ac43-0d3318b78cdb",
>       "abstraction_guid":"00000000-0000-0000-0000-000000000000"
>     }
>   ]
> }
> read 1 nmem
> 

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
