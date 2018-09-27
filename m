Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 599CE21138AA1
 for <linux-nvdimm@lists.01.org>; Thu, 27 Sep 2018 13:04:12 -0700 (PDT)
Subject: Re: [RFC workqueue/driver-core PATCH 2/5] async: Add support for
 queueing on specific NUMA node
References: <20180926214433.13512.30289.stgit@localhost.localdomain>
 <20180926215143.13512.56522.stgit@localhost.localdomain>
 <CAPcyv4iJOYiM+rHsM4GPifKNJ=X+AtV2MgWTn+f7u0VBzXb2og@mail.gmail.com>
 <d16cabf9-28f7-31e2-c43d-027738185518@linux.intel.com>
 <CAPcyv4iJeb-tJZVWRziwHQ-ug2P8Hgov2FSGvaXDOjw337kfMg@mail.gmail.com>
From: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Message-ID: <e9e09e7d-fee1-8736-82b3-13ba65879863@linux.intel.com>
Date: Thu, 27 Sep 2018 13:03:11 -0700
MIME-Version: 1.0
In-Reply-To: <CAPcyv4iJeb-tJZVWRziwHQ-ug2P8Hgov2FSGvaXDOjw337kfMg@mail.gmail.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: "Brown, Len" <len.brown@intel.com>, Linux-pm mailing list <linux-pm@vger.kernel.org>, Greg KH <gregkh@linuxfoundation.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, jiangshanlai@gmail.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, zwisler@kernel.org, Pavel Machek <pavel@ucw.cz>, Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On 9/27/2018 12:48 PM, Dan Williams wrote:
> On Thu, Sep 27, 2018 at 8:24 AM Alexander Duyck
> <alexander.h.duyck@linux.intel.com> wrote:
> [..]
>>>> - * Returns an async_cookie_t that may be used for checkpointing later.
>>>> - * @domain may be used in the async_synchronize_*_domain() functions to
>>>> - * wait within a certain synchronization domain rather than globally.  A
>>>> - * synchronization domain is specified via @domain.  Note: This function
>>>> - * may be called from atomic or non-atomic contexts.
>>>> + * Device specific version of async_schedule_near_domain that provides some
>>>> + * NUMA awareness based on the device node.
>>>> + */
>>>> +async_cookie_t async_schedule_dev_domain(async_func_t func, struct device *dev,
>>>> +                                        struct async_domain *domain)
>>>> +{
>>>> +       return async_schedule_near_domain(func, dev, dev_to_node(dev), domain);
>>>> +}
>>>> +EXPORT_SYMBOL_GPL(async_schedule_dev_domain);
>>>
>>> This seems unnecessary and restrictive. Callers may want to pass
>>> something other than dev as the parameter to the async function, and
>>> dev_to_node() is not on onerous burden to place on callers.
>>
>>
>> That is what async_schedule_near_domain is for, they can call that. The
>> "dev" versions of the calls as just supposed to be helpers since one of
>> the most common parameters to the async_schedule calls is a device, so I
>> thought I would just put together a function that takes care of all this
>> for us so I could drop an argument and avoid having to use dev_to_node
>> everywhere.
> 
> Yeah, makes sense, I guess I was reacting to the fact that this
> expands the number of exports unnecessarily. The other async routines
> are exported because they hide internal implementation details of the
> async implementation. The async_schedule_dev* helpers can just be
> static inline wrappers.

I can do them as inline wrappers for the next patch set. Shouldn't be 
too much of an issue.

Thanks.

- Alex

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
