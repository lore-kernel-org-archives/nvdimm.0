From: Jeff Moyer <jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [LSF/MM TOPIC] Future direction of DAX
Date: Tue, 17 Jan 2017 11:07:14 -0500
Message-ID: <x49r3411xhp.fsf@segfault.boston.devel.redhat.com>
References: <20170114002008.GA25379@linux.intel.com>
 <20170114082621.GC10498@birch.djwong.org>
 <x49wpduzseu.fsf@dhcp-25-115.bos.redhat.com>
 <20170117015033.GD10498@birch.djwong.org>
 <20170117075735.GB19654@infradead.org>
 <x49mvep4tzw.fsf@segfault.boston.devel.redhat.com>
 <20170117150638.GA3747@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20170117150638.GA3747-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> (Christoph Hellwig's
 message of "Tue, 17 Jan 2017 07:06:38 -0800")
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lsf-pc-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
List-Id: linux-nvdimm@lists.01.org

Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> writes:

> On Tue, Jan 17, 2017 at 09:54:27AM -0500, Jeff Moyer wrote:
>> I spoke with Dave before the holidays, and he indicated that
>> PMEM_IMMUTABLE would be an acceptable solution to allowing applications
>> to flush data completely from userspace.  I know this subject has been
>> beaten to death, but would you mind just summarizing your opinion on
>> this one more time?  I'm guessing this will be something more easily
>> hashed out at LSF, though.
>
> Come up with a prototype that doesn't suck and allows all fs features to
> actually work.

OK, I'll take this to mean that PMEM_IMMUTABLE is a non-starter.
Perhaps synchronous page faults (or whatever you want to call it) would
work, but...

> And show an application that actually cares and shows benefits on
> publicly available real hardware.

This is the crux of the issue.

> Until then go away and stop wasting everyones time.

Fair enough.  It seems fairly likely that this sort of functionality
would provide a big benefit.  But I agree we should have a real-world
use case as proof.

Thanks,
Jeff
