From: Jeff Moyer <jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [Qemu-devel] [RFC v2 1/2] virtio: add pmem driver
Date: Thu, 26 Apr 2018 13:24:17 -0400
Message-ID: <x49in8d6fum.fsf@segfault.boston.devel.redhat.com>
References: <20180425112415.12327-1-pagupta@redhat.com>
 <20180425112415.12327-2-pagupta@redhat.com>
 <CAPcyv4hvrB08XPTbVK0xT2_1Xmaid=-v3OMxJVDTNwQucsOHLA@mail.gmail.com>
 <CAPcyv4hiowWozV527sQA_e4fdgCYbD6xfG==vepAqu0hxQEQcw@mail.gmail.com>
 <x49o9i6885e.fsf@segfault.boston.devel.redhat.com>
 <1499190564.23017177.1524762938762.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <1499190564.23017177.1524762938762.JavaMail.zimbra-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
 (Pankaj Gupta's message of "Thu, 26 Apr 2018 13:15:38 -0400 (EDT)")
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Pankaj Gupta <pagupta-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, KVM list <kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, David Hildenbrand <david-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-nvdimm <linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org>, Ross Zwisler <ross.zwisler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Qemu Developers <qemu-devel-qX2TKyscuCcdnm+yROfE0A@public.gmane.org>, lcapitulino-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, niteshnarayanlal-PkbjNfxxIARBDgjK7y7TUQ@public.gmane.org, "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Marcel Apfelbaum <marcel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Nitesh Narayan Lal <nilal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Rik van Riel <riel-ebMLmSuQjDVBDgjK7y7TUQ@public.gmane.org>, Stefan Hajnoczi <stefanha-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Kevin Wolf <kwolf-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Xiao Guangrong <xiaoguangrong.eric-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Igor Mammedov <imammedo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-nvdimm@lists.01.org

Pankaj Gupta <pagupta-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> writes:

>> Ideally, qemu (seabios?) would advertise a platform capabilities
>> sub-table that doesn't fill in the flush bits.
>
> Could you please elaborate on this, how its related to disabling
> MAP_SYNC? We are not doing entire nvdimm device emulation. 

My mistake.  If you're not providing an NFIT, then you can ignore this
comment.  I'll have a closer look at your patches next week.

-Jeff
