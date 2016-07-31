From: yizhan <yizhan@redhat.com>
Subject: Re: [BUG] kernel NULL pointer dereference observed during pmem btt
 switch test
Date: Mon, 1 Aug 2016 01:19:26 +0800
Message-ID: <d83eeac2-49dc-4c45-9aea-7d68da4fbf7d@redhat.com>
References: <622794958.9574724.1469674652262.JavaMail.zimbra@redhat.com>
 <1762637089.9575520.1469676013321.JavaMail.zimbra@redhat.com>
 <CAPcyv4g5PpShWfXSV+KPJYW7GFrejUNjk=C1-ak=88iX8XczGA@mail.gmail.com>
 <CAPcyv4gGLfLbCWmzb5Yt+oVp2pKuGwVv6iY__O_DPmaV__OZDQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------0DDD91E46F0304F1951B6921"
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <CAPcyv4gGLfLbCWmzb5Yt+oVp2pKuGwVv6iY__O_DPmaV__OZDQ@mail.gmail.com>
Sender: linux-block-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-nvdimm <linux-nvdimm@ml01.01.org>, linux-block@vger.kernel.org
List-Id: linux-nvdimm@lists.01.org

This is a multi-part message in MIME format.
--------------0DDD91E46F0304F1951B6921
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit

On 07/30/2016 11:52 PM, Dan Williams wrote:
> On Thu, Jul 28, 2016 at 8:50 AM, Dan Williams <dan.j.williams@intel.com> wrote:
>> [ adding linux-block ]
>>
>> On Wed, Jul 27, 2016 at 8:20 PM, Yi Zhang <yizhan@redhat.com> wrote:
>>> Hello everyone
>>>
>>> Could you help check this issue, thanks.
>>>
>>> Steps I used:
>>> 1. Reserve 4*8G of memory for pmem by add kernel parameter "memmap=8G!4G memmap=8G!12G memmap=8G!20G memmap=8G!28G"
>>> 2. Execute below script
>>> #!/bin/bash
>>> pmem_btt_switch() {
>>>          sector_size_list="512 520 528 4096 4104 4160 4224"
>>>          for sector_size in $sector_size_list; do
>>>                  ndctl create-namespace -f -e namespace${1}.0 --mode=sector -l $sector_size
>>>                  ndctl create-namespace -f -e namespace${1}.0 --mode=raw
>>>          done
>>> }
>>>
>>> for i in 0 1 2 3; do
>>>          pmem_btt_switch $i &
>>> done
>> Thanks for the report.  This looks like del_gendisk() frees the
>> previous usage of the devt before the bdi is unregistered.  This
>> appears to be a general problem with all block drivers, not just
>> libnvdimm, since blk_cleanup_queue() is typically called after
>> del_gendisk().  I.e. it will always be the case that the bdi
>> registered with the devt allocated at add_disk() will still be alive
>> when del_gendisk()->disk_release() frees the previous devt number.
>>
>> I *think* the path forward is to allow the bdi to hold a reference
>> against the blk_alloc_devt() allocation until it is done with it.  Any
>> other ideas on fixing this object lifetime problem?
> Does the attached patch solve this for you?
Hi Dan
This patch works and the issue cannot be reproduced after several times' 
test, thanks

Another thing is during the bug verifying, I found below error message, 
could you check whether it is reasonable:
[  150.464620] Dev pmem1: unable to read RDB block 0
[  150.486897]  pmem1: unable to read partition table
[  150.486901] pmem1: partition table beyond EOD, truncated
[  151.133287] Buffer I/O error on dev pmem3, logical block 2, async 
page read
[  151.164620] Buffer I/O error on dev pmem3, logical block 2, async 
page read


Best Regards
Yi Zhang


--------------0DDD91E46F0304F1951B6921
Content-Type: text/x-log;
 name="dmesg.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="dmesg.log"

[  147.315954] nd_pmem btt0.1: No existing arenas
[  147.315955] nd_pmem btt3.1: No existing arenas
[  147.383257] pmem3s: detected capacity change from 0 to 8523182080
[  147.388988] pmem0s: detected capacity change from 8589934592 to 8523182080
[  147.396444] nd_pmem btt2.1: No existing arenas
[  147.396445] nd_pmem btt1.1: No existing arenas
[  147.430891] pmem2s: detected capacity change from 0 to 8523182080
[  147.430900] pmem1s: detected capacity change from 0 to 8523182080
[  147.478081] nd_pmem namespace2.0: unable to guarantee persistence of writes
[  147.521249] pmem2: detected capacity change from 0 to 8589934592
[  147.521487] nd_pmem namespace3.0: unable to guarantee persistence of writes
[  147.554917] pmem3: detected capacity change from 0 to 8589934592
[  147.580871] pmem2: detected capacity change from 8589934592 to 0
[  147.602631] nd_pmem namespace1.0: unable to guarantee persistence of writes
[  147.602635] nd_pmem namespace0.0: unable to guarantee persistence of writes
[  147.603497] pmem0: detected capacity change from 0 to 8589934592
[  147.666241] pmem1: detected capacity change from 0 to 8589934592
[  147.672306] nd_pmem namespace2.0: unable to guarantee persistence of writes
[  147.704536] pmem2: detected capacity change from 0 to 8589934592
[  147.734077] nd_pmem namespace3.0: unable to guarantee persistence of writes
[  147.766320] pmem3: detected capacity change from 0 to 8589934592
[  147.772506] Dev pmem0: unable to read RDB block 0
[  147.793773]  pmem0: unable to read partition table
[  147.793780] pmem0: partition table beyond EOD, truncated
[  147.865824] nd_pmem namespace0.0: unable to guarantee persistence of writes
[  147.898198] pmem0: detected capacity change from 0 to 8589934592
[  147.904714] nd_pmem namespace1.0: unable to guarantee persistence of writes
[  147.936305] pmem1: detected capacity change from 0 to 8589934592
[  147.971271] nd_pmem btt2.0: No existing arenas
[  148.030303] pmem2s: detected capacity change from 0 to 7582678528
[  148.041378] nd_pmem btt3.0: No existing arenas
[  148.070593] pmem3s: detected capacity change from 0 to 7582678528
[  148.135148] nd_pmem btt0.0: No existing arenas
[  148.135152] nd_pmem btt1.0: No existing arenas
[  148.167364] pmem1s: detected capacity change from 0 to 7582678528
[  148.167374] pmem0s: detected capacity change from 0 to 7582678528
[  148.176990] nd_pmem namespace2.0: unable to guarantee persistence of writes
[  148.212944] pmem2: detected capacity change from 0 to 8589934592
[  148.220145] nd_pmem namespace3.0: unable to guarantee persistence of writes
[  148.254861] pmem3: detected capacity change from 0 to 8589934592
[  148.261628] Dev pmem2: unable to read RDB block 0
[  148.284163]  pmem2: unable to read partition table
[  148.284166] pmem2: partition table beyond EOD, truncated
[  148.351329] nd_pmem namespace2.0: unable to guarantee persistence of writes
[  148.385262] pmem2: detected capacity change from 0 to 8589934592
[  148.390936] nd_pmem namespace3.0: unable to guarantee persistence of writes
[  148.423437] pmem3: detected capacity change from 0 to 8589934592
[  148.460822] nd_pmem namespace1.0: unable to guarantee persistence of writes
[  148.493065] pmem1: detected capacity change from 0 to 8589934592
[  148.539448] nd_pmem btt3.1: No existing arenas
[  148.611564] nd_pmem namespace0.0: unable to guarantee persistence of writes
[  148.611634] nd_pmem btt2.1: No existing arenas
[  148.644103] pmem0: detected capacity change from 0 to 8589934592
[  148.677860] pmem2s: detected capacity change from 0 to 7582678528
[  148.687916] nd_pmem namespace1.0: unable to guarantee persistence of writes
[  148.723037] pmem1: detected capacity change from 0 to 8589934592
[  148.730869] pmem0: detected capacity change from 8589934592 to 0
[  148.752875] nd_pmem namespace0.0: unable to guarantee persistence of writes
[  148.785398] pmem0: detected capacity change from 0 to 8589934592
[  148.822240] nd_pmem namespace3.0: unable to guarantee persistence of writes
[  148.854500] pmem3: detected capacity change from 0 to 8589934592
[  148.869679] nd_pmem namespace2.0: unable to guarantee persistence of writes
[  148.911291] pmem2: detected capacity change from 0 to 8589934592
[  148.919034] nd_pmem btt0.1: No existing arenas
[  148.948702] pmem0s: detected capacity change from 0 to 7582678528
[  148.958829] nd_pmem btt1.1: No existing arenas
[  149.019775] pmem1s: detected capacity change from 0 to 7582678528
[  149.050136] nd_pmem namespace3.0: unable to guarantee persistence of writes
[  149.082633] pmem3: detected capacity change from 0 to 8589934592
[  149.103815] nd_pmem namespace2.0: unable to guarantee persistence of writes
[  149.136176] pmem2: detected capacity change from 0 to 8589934592
[  149.184799] nd_pmem namespace0.0: unable to guarantee persistence of writes
[  149.218606] pmem0: detected capacity change from 0 to 8589934592
[  149.224931] nd_pmem btt3.0: No existing arenas
[  149.235318] pmem3s: detected capacity change from 8589934592 to 8580472832
[  149.241427] nd_pmem namespace1.0: unable to guarantee persistence of writes
[  149.241488] nd_pmem btt2.0: No existing arenas
[  149.247017] pmem2s: detected capacity change from 0 to 8580472832
[  149.277048] pmem1: detected capacity change from 0 to 8589934592
[  149.307015] nd_pmem namespace0.0: unable to guarantee persistence of writes
[  149.341856] pmem0: detected capacity change from 0 to 8589934592
[  149.372847] nd_pmem namespace1.0: unable to guarantee persistence of writes
[  149.405191] pmem1: detected capacity change from 0 to 8589934592
[  149.439029] nd_pmem namespace3.0: unable to guarantee persistence of writes
[  149.471169] pmem3: detected capacity change from 0 to 8589934592
[  149.502574] nd_pmem namespace2.0: unable to guarantee persistence of writes
[  149.534860] pmem2: detected capacity change from 0 to 8589934592
[  149.542808] nd_pmem namespace3.0: unable to guarantee persistence of writes
[  149.574676] pmem3: detected capacity change from 0 to 8589934592
[  149.608027] nd_pmem namespace2.0: unable to guarantee persistence of writes
[  149.640207] pmem2: detected capacity change from 0 to 8589934592
[  149.702443] nd_pmem btt0.0: No existing arenas
[  149.702445] nd_pmem btt1.0: No existing arenas
[  149.715351] pmem0s: detected capacity change from 0 to 8580472832
[  149.721028] pmem1s: detected capacity change from 8589934592 to 8580472832
[  149.729324] nd_pmem btt2.1: No existing arenas
[  149.729329] nd_pmem btt3.1: No existing arenas
[  149.735004] pmem3s: detected capacity change from 0 to 8448573440
[  149.739576] pmem2s: detected capacity change from 0 to 8448573440
[  149.782024] nd_pmem namespace3.0: unable to guarantee persistence of writes
[  149.829323] pmem3: detected capacity change from 0 to 8589934592
[  149.829562] nd_pmem namespace1.0: unable to guarantee persistence of writes
[  149.862662] pmem1: detected capacity change from 0 to 8589934592
[  149.870267] nd_pmem namespace2.0: unable to guarantee persistence of writes
[  149.902596] pmem2: detected capacity change from 0 to 8589934592
[  149.937580] nd_pmem namespace0.0: unable to guarantee persistence of writes
[  149.970071] pmem0: detected capacity change from 0 to 8589934592
[  149.976675] nd_pmem namespace3.0: unable to guarantee persistence of writes
[  150.008906] pmem3: detected capacity change from 0 to 8589934592
[  150.032619] nd_pmem namespace1.0: unable to guarantee persistence of writes
[  150.064691] pmem1: detected capacity change from 0 to 8589934592
[  150.070176] nd_pmem namespace2.0: unable to guarantee persistence of writes
[  150.102587] pmem2: detected capacity change from 0 to 8589934592
[  150.129946] nd_pmem namespace0.0: unable to guarantee persistence of writes
[  150.162165] pmem0: detected capacity change from 0 to 8589934592
[  150.210180] nd_pmem btt2.0: No existing arenas
[  150.210182] nd_pmem btt3.0: No existing arenas
[  150.220950] pmem3s: detected capacity change from 0 to 8448573440
[  150.229106] pmem2s: detected capacity change from 8589934592 to 8448573440
[  150.237939] nd_pmem btt1.1: No existing arenas
[  150.247641] pmem1s: detected capacity change from 0 to 8448573440
[  150.258315] nd_pmem btt0.1: No existing arenas
[  150.264070] pmem0s: detected capacity change from 0 to 8448573440
[  150.319992] nd_pmem namespace1.0: unable to guarantee persistence of writes
[  150.366356] pmem1: detected capacity change from 0 to 8589934592
[  150.366678] nd_pmem namespace2.0: unable to guarantee persistence of writes
[  150.402532] pmem2: detected capacity change from 0 to 8589934592
[  150.407886] nd_pmem namespace3.0: unable to guarantee persistence of writes
[  150.444465] pmem3: detected capacity change from 0 to 8589934592
[  150.464620] Dev pmem1: unable to read RDB block 0
[  150.486897]  pmem1: unable to read partition table
[  150.486901] pmem1: partition table beyond EOD, truncated
[  150.536626] nd_pmem namespace0.0: unable to guarantee persistence of writes
[  150.568956] pmem0: detected capacity change from 0 to 8589934592
[  150.590809] nd_pmem namespace1.0: unable to guarantee persistence of writes
[  150.622145] nd_pmem namespace3.0: unable to guarantee persistence of writes
[  150.623098] pmem1: detected capacity change from 0 to 8589934592
[  150.654534] pmem3: detected capacity change from 0 to 8589934592
[  150.660707] nd_pmem namespace2.0: unable to guarantee persistence of writes
[  150.692821] pmem2: detected capacity change from 0 to 8589934592
[  150.728067] nd_pmem namespace0.0: unable to guarantee persistence of writes
[  150.760343] pmem0: detected capacity change from 0 to 8589934592
[  150.798537] nd_pmem btt1.0: No existing arenas
[  150.804651] pmem1s: detected capacity change from 0 to 8448573440
[  150.829937] nd_pmem btt3.1: No existing arenas
[  150.847261] pmem3s: detected capacity change from 8589934592 to 8320671744
[  150.858221] nd_pmem btt0.0: No existing arenas
[  150.867579] pmem0s: detected capacity change from 0 to 8448573440
[  150.875491] nd_pmem btt2.1: No existing arenas
[  150.881240] pmem2s: detected capacity change from 0 to 8320671744
[  150.925384] nd_pmem namespace1.0: unable to guarantee persistence of writes
[  150.962120] pmem1: detected capacity change from 0 to 8589934592
[  150.985113] nd_pmem namespace2.0: unable to guarantee persistence of writes
[  151.029504] pmem2: detected capacity change from 0 to 8589934592
[  151.029861] nd_pmem namespace3.0: unable to guarantee persistence of writes
[  151.061681] pmem3: detected capacity change from 0 to 8589934592
[  151.093674] nd_pmem namespace1.0: unable to guarantee persistence of writes
[  151.125684] pmem1: detected capacity change from 0 to 8589934592
[  151.133287] Buffer I/O error on dev pmem3, logical block 2, async page read
[  151.164620] Buffer I/O error on dev pmem3, logical block 2, async page read
[  151.243026] nd_pmem namespace3.0: unable to guarantee persistence of writes
[  151.275200] pmem3: detected capacity change from 0 to 8589934592
[  151.288175] nd_pmem namespace2.0: unable to guarantee persistence of writes
[  151.320536] pmem2: detected capacity change from 0 to 8589934592
[  151.347556] nd_pmem namespace0.0: unable to guarantee persistence of writes
[  151.379724] pmem0: detected capacity change from 0 to 8589934592
[  151.407539] nd_pmem namespace0.0: unable to guarantee persistence of writes
[  151.442647] pmem0: detected capacity change from 0 to 8589934592
[  151.450053] nd_pmem btt1.1: No existing arenas
[  151.456290] pmem1s: detected capacity change from 0 to 8320671744
[  151.495572] nd_pmem namespace1.0: unable to guarantee persistence of writes
[  151.540294] pmem1: detected capacity change from 0 to 8589934592
[  151.546802] nd_pmem btt0.1: No existing arenas
[  151.552513] pmem0s: detected capacity change from 0 to 8320671744
[  151.563179] pmem1: detected capacity change from 8589934592 to 0
[  151.590517] nd_pmem namespace1.0: unable to guarantee persistence of writes
[  151.622554] pmem1: detected capacity change from 0 to 8589934592
[  151.659503] nd_pmem namespace0.0: unable to guarantee persistence of writes
[  151.691927] pmem0: detected capacity change from 0 to 8589934592
[  151.720570] nd_pmem namespace0.0: unable to guarantee persistence of writes
[  151.752515] pmem0: detected capacity change from 0 to 8589934592

--------------0DDD91E46F0304F1951B6921--
