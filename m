Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-qt0-x241.google.com (mail-qt0-x241.google.com
 [IPv6:2607:f8b0:400d:c0d::241])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3FE45803DA
 for <linux-nvdimm@lists.01.org>; Tue, 14 Mar 2017 12:52:29 -0700 (PDT)
Received: by mail-qt0-x241.google.com with SMTP id x35so11313345qtc.1
 for <linux-nvdimm@lists.01.org>; Tue, 14 Mar 2017 12:52:29 -0700 (PDT)
From: Linda Knippers <ljklists@gmail.com>
Subject: Re: [ndctl PATCH v3 6/7] ndctl: add a BTT check utility
References: <20170304061307.13530-1-vishal.l.verma@intel.com>
 <20170304061307.13530-7-vishal.l.verma@intel.com> <58C72AA6.1020700@hpe.com>
 <1489519422.2541.2.camel@intel.com>
Message-ID: <58C849F9.3060106@gmail.com>
Date: Tue, 14 Mar 2017 15:52:25 -0400
MIME-Version: 1.0
In-Reply-To: <1489519422.2541.2.camel@intel.com>
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
To: "Verma, Vishal L" <vishal.l.verma@intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On 3/14/2017 3:23 PM, Verma, Vishal L wrote:
> On Mon, 2017-03-13 at 19:26 -0400, Linda Knippers wrote:
>> Hi Vishal,
>>
>> Thanks for all your work on this.  I finally got a chance to do some
>> testing and have a few usability suggestions for you to consider.
>
> Thanks for the comments, Linda. See below, but yes I can send follow on
> patches for these.

Great, later is fine.  More below.
>
>>
>> On 03/04/2017 01:13 AM, Vishal Verma wrote:
>> <snip>
>>>
>>> */
>>> +	raw_mode = ndctl_namespace_get_raw_mode(ndns);
>>> +
>>> +	/*
>>> +	 * Putting the namespace into raw mode will allow us to
>>> access
>>> +	 * the btt metadata.
>>> +	 */
>>> +	rc = ndctl_namespace_set_raw_mode(ndns, 1);
>>> +	if (rc < 0) {
>>> +		err(bttc, "%s: failed to set the raw mode flag:
>>> %d\n",
>>> +			devname, rc);
>>> +		goto out_ns;
>>> +	}
>>
>> When I ran the utility as non-root, I got this:
>> $ ndctl check-namespace namespace3.0
>> namespace3.0: namespace_check: namespace3.0: failed to set the raw
>> mode flag: -6
>> error checking namespaces: No such device or address
>>
>> I think it ought to end with Permission denied, which it would do if
>> ndctl_namespace_get_raw_mode() returned with -errno rather than a
>> hard
>> coded ENXIO.
>
> Good point - I'll fix this (in a follow on patch).
>
>>
>> If that's main reason that setting the raw mode flag can fail, then
>> the
>> err() could be an info().  That would simplify the output.
>
> I think it should still be an error as it is a fatal problem and we
> have to abort..

It's just a bit confusing when the most likely cause is not running
as root.  Otherwise, that error probably can't really happen.
In other places you don't even check the return value for the function,
probably because it doesn't really happen.

>
> <snip>
>
>>> +
>>> +	rc = btt_info_read_verify(bttc, btt_sb, bttc->start_off);
>>> +	if (rc) {
>>> +		rc = btt_recover_first_sb(bttc);
>>> +		if (rc) {
>>> +			info(bttc, "Unable to recover any BTT info
>>> blocks\n");
>>> +			goto out_close;
>>
>> When I ran this on a namespace that never had a BTT, I thought I'd
>> get a error
>> basically saying that I'm screwed, but instead I got:
>>
>> $ sudo ndctl check-namespace namespace1.0
>> error checking namespaces: No such device or address
>>
>> It seems like the info() above is rather important and should be an
>> err().
>> For a checker, maybe verbose should be the default anyway.
>
> Ok - let me revisit the no BTT case and see if we can print out
> something better.

The message that you have there is probably good enough, it just
didn't come out without the verbose option.  The "No such device or address"
part is a bit wrong though because the device is there, there's just
no btt on it.
>
>>
>>> +		}
>>> +		rc = btt_info_read_verify(bttc, btt_sb, bttc-
>>>> start_off);
>>> +		if (rc)
>>> +			goto out_close;
>>> +	}
>>> +	rc = btt_discover_arenas(bttc);
>>> +	if (rc)
>>> +		goto out_close;
>>> +
>>> +	rc = btt_create_mappings(bttc);
>>> +	if (rc)
>>> +		goto out_close;
>>> +
>>> +	rc = btt_check_arenas(bttc);
>>> +
>>> +	btt_remove_mappings(bttc);
>>> + out_close:
>>> +	close(bttc->fd);
>>> + out_sb:
>>> +	free(btt_sb);
>>> + out_ns:
>>> +	ndctl_namespace_set_raw_mode(ndns, raw_mode);
>>> +	ndctl_namespace_disable_invalidate(ndns);
>>> +	if (disabled_flag)
>>> +		if(ndctl_namespace_enable(ndns) < 0)
>>> +			info(bttc, "%s: failed to re-enable
>>> namespace\n",
>>> +				devname);
>>
>> I didn't get this error but it seems rather important too.
>
> This should normally never happen, and I had it as an info because at
> this point we can't really do anything about it. Any check/repair has
> already completed, and if we weren't able to enable the namespace, the
> user likely won't either for the same reason.. In any case, it seems
> more like an informational message since nothing can be done about it,
> and it doesn't affect any future flow..

The reason I think it should be an error is that something went wrong,
whether you can do anything about it in the checker or not.  Without an
error the user will have no idea because the function returns successfully.
That's actually true for the two ndctl_namespace...() functions above where
the return value isn't even checked.  If the namespace is left in an
unclean state or unusable state, that would be good to know before the user
attempts to use the namespace and gets some other error.

For something like a checker, more information is better, which contradicts
my first comment. :-)

-- ljk
>
>>
>> Thanks,
>>
>> - ljk
>>
>>> + out_bttc:
>>> +	free(bttc);
>>> +	return rc;
>>> +}
>>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
