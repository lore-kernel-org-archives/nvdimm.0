From: yizhan <yizhan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: kernel BUG observed during ndctl Unit Tests on 4.8.0-rc2
Date: Wed, 24 Aug 2016 03:45:20 +0800
Message-ID: <4a567c42-3434-a558-5bff-8b482c754259@redhat.com>
References: <448644206.3016525.1471849509227.JavaMail.zimbra@redhat.com>
 <488108969.3025505.1471852323338.JavaMail.zimbra@redhat.com>
 <CAPcyv4jAOZ0tQWXpU3SMhytTPEmXvbSpPc2T=RKCVeeP-1Ks-A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <CAPcyv4jAOZ0tQWXpU3SMhytTPEmXvbSpPc2T=RKCVeeP-1Ks-A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
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
Cc: linux-nvdimm <linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org>
List-Id: linux-nvdimm@lists.01.org



On 08/23/2016 07:08 AM, Dan Williams wrote:
> On Mon, Aug 22, 2016 at 12:52 AM, Yi Zhang <yizhan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>> Hi folks
>>
>> I'm testing ndctl unit test on 4.8.0-rc2, always can encounter the kernel BUG, anyone can help check it?
>> I have list all the log below:
>>
>> http://pastebin.com/JUiEGQUE  -> devm_nvdimm_memremap+0x18d/0x280
>> http://pastebin.com/MmazZj3K  -> kfree+0x56/0x170
>> http://pastebin.com/4kbucxPy  -> kfree+0x56/0x170
>> http://pastebin.com/kBsBicFM  -> kfree+0x56/0x170
>> http://pastebin.com/CaVKTYzc  -> strcmp+0x16/0x30
>> http://pastebin.com/pFWYWTDg  -> kfree+0x56/0x170
>>
>> Another server which have NVDIMM:
>> http://pastebin.com/y25QT2Dz  -> __kmalloc+0x9d/0x200
>> http://pastebin.com/z6xp2Usa  -> kfree+0x56/0x170
>> http://pastebin.com/eqmiqivN  -> kfree+0x56/0x170
>> http://pastebin.com/jA0RHSbf  -> kmem_cache_free+0x65/0x1e0
> Can you send your kernel config and the full log since boot?  When did
> this start failing?  I.e. might it be possible to bisect?
Hi Dan

Finally found below commit introduced this bug by git bisect.
7bfe97c tools/testing/nvdimm: add virtual ramdisk range

Below is the config and boot log:
http://pastebin.com/TnLA5abh      kernel config
http://pastebin.com/WDvjmH47    kernel dmesg

Pls let me if you need more info.

Thanks
Yi
