Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g2t2353.austin.hpe.com (g2t2353.austin.hpe.com [15.233.44.26])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9FB2821A04804
 for <linux-nvdimm@lists.01.org>; Fri,  7 Apr 2017 13:29:04 -0700 (PDT)
Subject: Re: panics related to nfit_test?
References: <58E793E8.8070507@hpe.com>
 <CAPcyv4jfCZMpNAC=-vG0a_koAfe-Vrr_+xcHXw1=TD+3DsqN+Q@mail.gmail.com>
 <58E7C875.8050008@hpe.com>
From: Linda Knippers <linda.knippers@hpe.com>
Message-ID: <58E7F689.8010709@hpe.com>
Date: Fri, 7 Apr 2017 16:28:57 -0400
MIME-Version: 1.0
In-Reply-To: <58E7C875.8050008@hpe.com>
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

On 04/07/2017 01:12 PM, Linda Knippers wrote:
> On 04/07/2017 12:44 PM, Dan Williams wrote:
>> On Fri, Apr 7, 2017 at 6:28 AM, Linda Knippers <linda.knippers@hpe.com> wrote:
>> I've seen reports of this crash
>> signature from the team trying to integrate the ndctl unit tests into
>> the 0day kbuild robot, but I have thus far been unable to reproduce
>> them. On my system if I do:
>>
>> # modprobe nfit_test
>> # rmmod nfit_test
>> rmmod: ERROR: Module nfit_test is in use
>>
>> Are you saying you are able to remove nfit_test on your system without
>> first disabling regions?
> 
> No, sorry.  I missed that step in my description.  I'm doing 'ndctl disable-region all'
> before the rmmod.

I've been doing a bit more testing and once, I had 'ndctl check' make it through
all the tests and pass.  A few times I've made it part way through the tests before
I hit the panic.  However, if I just modprobe the modules, disable the regions,
and then rmmod nfit_test, it panics for me 100% of the time.  Try this in a script.

modprobe nfit
modprobe dax
modprobe dax_pmem
modprobe libnvdimm
modprobe nd_blk
modprobe nd_btt
modprobe nd_e820
modprobe nd_pmem
lsmod |grep nfit
modprobe nfit_test
lsmod |grep nfit
ndctl disable-region all
rmmod nfit_test

-- ljk

> 
> -- ljk
> 
> 

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
