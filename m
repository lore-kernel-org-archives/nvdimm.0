From: Boaz Harrosh <boaz-/8YdC2HfS5554TAoqtyWWQ@public.gmane.org>
Subject: Re: xfs: untangle the direct I/O and DAX path, fix DAX locking
Date: Tue, 28 Jun 2016 16:56:30 +0300
Message-ID: <5772820E.2080403@plexistor.com>
References: <1466609236-23801-1-git-send-email-hch@lst.de>
 <20160623232446.GA12670@dastard> <20160624072612.GA22205@lst.de>
 <20160624230045.GG12670@dastard> <20160628131059.GA30475@lst.de>
 <57727B27.7060104@plexistor.com> <20160628133928.GB31283@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20160628133928.GB31283-jcswGhMUV9g@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, xfs-VZNHf3L845pBDgjK7y7TUQ@public.gmane.org
List-Id: linux-nvdimm@lists.01.org

On 06/28/2016 04:39 PM, Christoph Hellwig wrote:
> On Tue, Jun 28, 2016 at 04:27:03PM +0300, Boaz Harrosh wrote:
>>> Right.  And an existing application can get DAX turned on under its
>>> back, and will now suddently get different synchronization behavior.
>>> That is if it's writes happen to be aligned to the fs block size.
>>>
>>
>> Is there an actual application that does that? or is this purely
>> theoretical right now?
> 
> Lots of them.  The typical case is multithreaded (or preforked like old
> apache) daemons that use O_APPEND to write to a common log file.  Then
> again those log records will usually not be 4k aligned, so they'd still
> accidentally get the exclusive locking even without this patch.  But
> beware the case where a log record actually matches the alignment..
> 

But O_APPEND is exclusion problem of i_size update not of the actual memcpy
done in parallel or not.

Actually with O_APPEND each write request should write a different region
of the file, there are no overlapping writes. And no issue of which version of the
write came last and got its data written.

If it is the issue of isize update vs O_APPEND is a different issue don't
you think? One way that we solved it is to update isize = isize + len;
atomically before starting the IO, then on the error case sub the unwritten
bytes. And still allow concurrent writers. I agree that isize updates needs
to be atomic, but why does the memcpy?

And BTW in NFS O_APPEND concurrent readers to a writer may see
ZEROs in the interim.

I still don't see how an application can use the fact that two writers
will not give them mixed records. And surly it does not work on a shared
FS. So I was really wondering if you know of any such app

Thanks
Boaz

>>
>>
>> Thanks
>> Boaz
> ---end quoted text---
> 
