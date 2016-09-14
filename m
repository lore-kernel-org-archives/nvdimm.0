From: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH 06/10] dax: provide an iomap based fault handler
Date: Wed, 14 Sep 2016 11:07:59 -0600
Message-ID: <20160914170759.GA14196@linux.intel.com>
References: <1473438884-674-1-git-send-email-hch@lst.de>
 <1473438884-674-7-git-send-email-hch@lst.de>
 <20160913231039.GF26002@linux.intel.com>
 <20160914071910.GC17278@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160914071910.GC17278-jcswGhMUV9g@public.gmane.org>
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
Cc: linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org
List-Id: linux-nvdimm@lists.01.org

On Wed, Sep 14, 2016 at 09:19:10AM +0200, Christoph Hellwig wrote:
> On Tue, Sep 13, 2016 at 05:10:39PM -0600, Ross Zwisler wrote:
> > If you stick a space in front of the labels (as is done in the rest of dax.c)
> > it prevents future patches from using them at the beginning of hunks.  Here's a
> > patch adding a random space as an example:
> 
> The spaces in front of labels are a fairly horrible style.  But given
> that the rest of the file uses them I'll add them back.

I'll bite - why do you think adding a space before labels is a "fairly
horrible style"?  Adding them gives a tangible benefit for unified diffs and
patches because it's much more useful to know that a change is in a given
function than that it follows a label called "out", which could be defined
many times in a given file.  Again, the example:

@@ -908,6 +908,7 @@ out:
                return VM_FAULT_OOM | major;
        /* -EBUSY is fine, somebody else faulted on the same PTE */
        if ((error < 0) && (error != -EBUSY))
                return VM_FAULT_SIGBUS | major;
+
        return VM_FAULT_NOPAGE | major;
 }

vs

@@ -908,6 +908,7 @@ int dax_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
                return VM_FAULT_OOM | major;
        /* -EBUSY is fine, somebody else faulted on the same PTE */
        if ((error < 0) && (error != -EBUSY))
                return VM_FAULT_SIGBUS | major;
+
        return VM_FAULT_NOPAGE | major;
 }

where 'out' is a label without a leading space in the first case and with a
leading space in the second.
