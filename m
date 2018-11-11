Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1A4172117CE94
 for <linux-nvdimm@lists.01.org>; Sun, 11 Nov 2018 15:27:35 -0800 (PST)
Subject: Re: [driver-core PATCH v6 2/9] async: Add support for queueing on
 specific NUMA node
References: <154170028986.12967.2108024712555179678.stgit@ahduyck-desk1.jf.intel.com>
 <154170041079.12967.13132220574997822111.stgit@ahduyck-desk1.jf.intel.com>
 <20181111193208.GB8332@kroah.com>
 <CAPcyv4hofCTYMNN=Ow=o4RRuUPM=GLWajNAT9q6WWkuV47te_w@mail.gmail.com>
 <20181111203541.GB16871@kroah.com>
From: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Message-ID: <77b6544a-2a32-b8a4-3f3f-575193f04302@linux.intel.com>
Date: Sun, 11 Nov 2018 15:27:32 -0800
MIME-Version: 1.0
In-Reply-To: <20181111203541.GB16871@kroah.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Greg KH <gregkh@linuxfoundation.org>, Dan Williams <dan.j.williams@intel.com>
Cc: "Brown, Len" <len.brown@intel.com>, bvanassche@acm.org, Linux-pm mailing list <linux-pm@vger.kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, jiangshanlai@gmail.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>, zwisler@kernel.org, Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On 11/11/2018 12:35 PM, Greg KH wrote:
> On Sun, Nov 11, 2018 at 11:53:20AM -0800, Dan Williams wrote:
>> On Sun, Nov 11, 2018 at 11:32 AM Greg KH <gregkh@linuxfoundation.org> wrote:
>>>
>>> On Thu, Nov 08, 2018 at 10:06:50AM -0800, Alexander Duyck wrote:
>>>> Introduce four new variants of the async_schedule_ functions that allow
>>>> scheduling on a specific NUMA node.
>>>>
>>>> The first two functions are async_schedule_near and
>>>> async_schedule_near_domain end up mapping to async_schedule and
>>>> async_schedule_domain, but provide NUMA node specific functionality. They
>>>> replace the original functions which were moved to inline function
>>>> definitions that call the new functions while passing NUMA_NO_NODE.
>>>>
>>>> The second two functions are async_schedule_dev and
>>>> async_schedule_dev_domain which provide NUMA specific functionality when
>>>> passing a device as the data member and that device has a NUMA node other
>>>> than NUMA_NO_NODE.
>>>>
>>>> The main motivation behind this is to address the need to be able to
>>>> schedule device specific init work on specific NUMA nodes in order to
>>>> improve performance of memory initialization.
>>>>
>>>> Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
>>>> ---
>>>
>>> No one else from Intel has reviewed/verified this code at all?
>>>
>>> Please take advantages of the resources you have that most people do
>>> not, get reviewes from your coworkers please before you send this out
>>> again, as they can give you valuable help before the community has to
>>> review the code...
>>
>> I tend to be suspicious of code that arrives on the mailing list
>> day-one with a series of company-internal reviewed-by tags. Sometimes
>> there is preliminary work that can be done internally, but I think we
>> should prefer to do review in the open as much as possible where it
>> does not waste community time. Alex and I did reach a general internal
>> consensus to send this out and get community feedback, but I assumed
>> to do the bulk of the review in parallel with everyone else. That said
>> I think it's fine to ask for some other acks before you take a look,
>> but let's do that in the open.
> 
> Doing it in the open is great, see my response to Pavel for the history
> of why I am normally suspicious of this, and why I wrote the above.
> 
> Also this patchset has had a long history of me asking for things, and
> not seeing the changes happen (hint, where are the benchmark numbers I
> asked for a long time ago?)  Touching the driver core like this is
> tricky, and without others helping in review and test, it makes me
> suspicious that it is not happening.
> 
> This would be a great time for some other people to do that review :)
> 
> thanks,
> 
> greg k-h

Is there any specific benchmark test you were wanting me to run? As far 
as crude numbers this patch set started out specifically focused on 
patch 9/9, but I thought it best to apply it more generically as I found 
we could still run into the issue if we enabled async_probe.

What I have seen on several systems is a pretty significant improvement 
in initialization time for persistent memory. In the case of 3TB of 
memory being initialized on a single node the improvement in the worst 
case was from about 36s down to 26s for total initialization time.

I plan to resubmit this set after plumber's since there were a few typos 
and bits of comment left over in a patch description that needed to be 
sorted out. I will try to make certain to have any benchmark data I have 
included with the set the next time I put it out.

Thanks.

- Alex
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
