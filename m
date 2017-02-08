From: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: read failure (was Re: mmap dio write failure)
Date: Tue, 7 Feb 2017 21:05:21 -0800
Message-ID: <CAPcyv4iCz9SqJkoKYr-RWxV4FmqPB1Wfkx_A_jE-S5Unpo-5Pw@mail.gmail.com>
References: <20170120044007.kwevjo7nawwolagy@XZHOUW.usersys.redhat.com>
 <20170208035105.lvewz5ce7xbu5zud@XZHOUW.usersys.redhat.com>
 <CAPcyv4iF2xH=9FHDMqb8OYMFO45GkiEEKf1y73Q7scGQSJniag@mail.gmail.com>
 <20170208044959.rq3ofmsjth2oeu2u@XZHOUW.usersys.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20170208044959.rq3ofmsjth2oeu2u-E9dkjZ7ERC1QcClZ3XN9yxcY2uh10dtjAL8bYrjMMd8@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Xiong Zhou <xzhou-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-nvdimm <linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org>, Eryu Guan <eguan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-nvdimm@lists.01.org

On Tue, Feb 7, 2017 at 8:49 PM, Xiong Zhou <xzhou-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On Tue, Feb 07, 2017 at 08:10:14PM -0800, Dan Williams wrote:
>> On Tue, Feb 7, 2017 at 7:51 PM, Xiong Zhou <xzhou-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>> > On Fri, Jan 20, 2017 at 12:40:07PM +0800, Xiong Zhou wrote:
>> >> Hi,
>> >>
>> >> At first, I am not sure whether this is an issue.
>> >>
>> >> mmap a file in a DAX mountpoint, open another file
>> >> in a non-DAX mountpoint with O_DIRECT, write the
>> >> mapped area to the other file.
>> >>
>> >> This write Success on pmem ramdisk(memmap=2G!20G like)
>> >> This write Fail(Bad address) on nvdimm pmem devices.
>> >> This write Fail(Bad address) on brd based ramdisk.
>> >>
>> >> If we skip the O_DIRECT flag, all tests pass.
>> >>
>> >> If we write from DAX to DAX, all tests pass.
>> >> If we write from non-DAX to DAX, all tests pass.
>> >>
>> > snip..
>> >
>> > To falloc instead of pwrite while initiating test files,
>> > ( Thanks Ross! :)
>> > the write call returned success, however the following
>> > read back to mmaped area FAILED the same way:
>> >
>> > return (Bad address) on raw-mode nvdimm device;
>> > return (Success)     on memory-mode nvdimm device;
>> > return (Bad address) on brd based ramdisk.
>> >
>> > Also, this only happends with O_DIRECT flag on.
>> >
>> > This smells like an issue to me, still looking into why
>> > read can't get that page..
>> >
>>
>> Why does it smell like an issue? Any path that calls get_user_pages()
>
> Because the write call gets its page and succeeds, while read back fails.
> __get_user_pages on the same address first pass, then fail.

Ok, I might have misread your description. Can you tell me the exact
reproduction steps so I can give it a try?
