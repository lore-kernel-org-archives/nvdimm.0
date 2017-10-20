From: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [Qemu-devel] [RFC 2/2] KVM: add virtio-pmem driver
Date: Fri, 20 Oct 2017 08:05:09 -0700
Message-ID: <CAPcyv4hHjCpm4AnLz2SdtjNMasV182Cw-jA+Cv9DjmE1Fa26kA@mail.gmail.com>
References: <20171012155027.3277-1-pagupta@redhat.com>
 <20171012155027.3277-3-pagupta@redhat.com>
 <20171017071633.GA9207@infradead.org>
 <1441791227.21027037.1508226056893.JavaMail.zimbra@redhat.com>
 <20171017080236.GA27649@infradead.org>
 <670833322.21037148.1508229041158.JavaMail.zimbra@redhat.com>
 <20171018130339.GB29767@stefanha-x1.localdomain>
 <CAPcyv4h6aFkyHhh4R4DTznbSCLf9CuBoszk0Q1gB5EKNcp_SeQ@mail.gmail.com>
 <20171019080149.GB10089@infradead.org>
 <CAPcyv4j=Cdp68C15HddKaErpve2UGRfSTiL6bHiS=3gQybz9pg@mail.gmail.com>
 <20171020080049.GA25471@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20171020080049.GA25471-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
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
Cc: Kevin Wolf <kwolf-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, xiaoguangrong eric <xiaoguangrong.eric-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, KVM list <kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Pankaj Gupta <pagupta-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Stefan Hajnoczi <stefanha-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, David Hildenbrand <david-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, ross zwisler <ross.zwisler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Qemu Developers <qemu-devel-qX2TKyscuCcdnm+yROfE0A@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Stefan Hajnoczi <stefanha-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-nvdimm <linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org>, Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Nitesh Narayan Lal <nilal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-nvdimm@lists.01.org

On Fri, Oct 20, 2017 at 1:00 AM, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:
> On Thu, Oct 19, 2017 at 11:21:26AM -0700, Dan Williams wrote:
>> The difference is that nvdimm_flush() is not mandatory, and that the
>> platform will automatically perform the same flush at power-fail.
>> Applications should be able to assume that if they are using MAP_SYNC
>> that no other coordination with the kernel or the hypervisor is
>> necessary.
>>
>> Advertising this as a generic Persistent Memory range to the guest
>> means that the guest could theoretically use it with device-dax where
>> there is no driver or filesystem sync interface. The hypervisor will
>> be waiting for flush notifications and the guest will just issue cache
>> flushes and sfence instructions. So, as far as I can see we need to
>> differentiate this virtio-model from standard "Persistent Memory" to
>> the guest and remove the possibility of guests/applications making the
>> wrong assumption.
>
> So add a flag that it is not.  We already have the nd_volatile type,
> that is special.  For now only in Linux, but I think adding this type
> to the spec eventually would be very useful for efficiently exposing
> directly mappable device to VM guests.

Right, that's the same recommendation I gave.

    https://lists.gnu.org/archive/html/qemu-devel/2017-07/msg08404.html

...so maybe I'm misunderstanding your concern? It sounds like we're on
the same page.
