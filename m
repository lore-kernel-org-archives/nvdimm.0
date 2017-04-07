From: Linda Knippers <ljknh-DaQTI0RpDDMAvxtiuMwx3w@public.gmane.org>
Subject: Re: panics related to nfit_test?
Date: Fri, 7 Apr 2017 17:55:07 -0400
Message-ID: <58E80ABB.3040807@ymail.com>
References: <58E793E8.8070507@hpe.com>
 <CAPcyv4jfCZMpNAC=-vG0a_koAfe-Vrr_+xcHXw1=TD+3DsqN+Q@mail.gmail.com>
 <58E7C875.8050008@hpe.com> <58E7F689.8010709@hpe.com>
 <CAPcyv4gS+z_HiMrgvayDaQr2qNKtZ+6boMdDZj0hQrxJhc+U6g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <CAPcyv4gS+z_HiMrgvayDaQr2qNKtZ+6boMdDZj0hQrxJhc+U6g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org" <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Id: linux-nvdimm@lists.01.org



On 04/07/2017 05:46 PM, Dan Williams wrote:
> On Fri, Apr 7, 2017 at 1:28 PM, Linda Knippers <linda.knippers-ZPxbGqLxI0U@public.gmane.org> wrote:
>> On 04/07/2017 01:12 PM, Linda Knippers wrote:
>>> On 04/07/2017 12:44 PM, Dan Williams wrote:
>>>> On Fri, Apr 7, 2017 at 6:28 AM, Linda Knippers <linda.knippers-ZPxbGqLxI0U@public.gmane.org> wrote:
>>>> I've seen reports of this crash
>>>> signature from the team trying to integrate the ndctl unit tests into
>>>> the 0day kbuild robot, but I have thus far been unable to reproduce
>>>> them. On my system if I do:
>>>>
>>>> # modprobe nfit_test
>>>> # rmmod nfit_test
>>>> rmmod: ERROR: Module nfit_test is in use
>>>>
>>>> Are you saying you are able to remove nfit_test on your system without
>>>> first disabling regions?
>>>
>>> No, sorry.  I missed that step in my description.  I'm doing 'ndctl disable-region all'
>>> before the rmmod.
>>
>> I've been doing a bit more testing and once, I had 'ndctl check' make it through
>> all the tests and pass.  A few times I've made it part way through the tests before
>> I hit the panic.  However, if I just modprobe the modules, disable the regions,
>> and then rmmod nfit_test, it panics for me 100% of the time.  Try this in a script.
>>
>> modprobe nfit
>> modprobe dax
>> modprobe dax_pmem
>> modprobe libnvdimm
>> modprobe nd_blk
>> modprobe nd_btt
>> modprobe nd_e820
>> modprobe nd_pmem
>> lsmod |grep nfit
>> modprobe nfit_test
>> lsmod |grep nfit
>> ndctl disable-region all
>> rmmod nfit_test
>>
> 
> What distribution are you using? This loop is running fine in my
> Fedora Rawhide virtual machine environment. The other report of this
> was from a Debian environment. So I wonder if there is some timing
> differences related to udev or libkmod that prevent me from hitting
> the failure condition?

I'm running RHEL7.3 with a 4.11-rc5 kernel on bare metal with no
physical NVDIMMs.   My system is a 2-socket box with E5-2695 v4
processors and a total of 72 cores with HT on.  Maybe you need
more cores.

-- ljk
