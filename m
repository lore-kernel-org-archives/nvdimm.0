From: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [Qemu-devel] [ndctl PATCH 0/8] dimm label space initialization
 support
Date: Wed, 19 Oct 2016 12:41:54 -0700
Message-ID: <CAPcyv4gbRE-ALJM6EHv6fM3Kq02HeZFMLF5T63J5qaJmHWvQCg@mail.gmail.com>
References: <147689566876.11015.13898062253087685236.stgit@dwillia2-desk3.amr.corp.intel.com>
 <6ceb7075-71fc-b725-8a1c-a7d8c727770e@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <6ceb7075-71fc-b725-8a1c-a7d8c727770e-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Eric Blake <eblake-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-nvdimm <linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org>, qemu-devel-qX2TKyscuCcdnm+yROfE0A@public.gmane.org
List-Id: linux-nvdimm@lists.01.org

On Wed, Oct 19, 2016 at 11:42 AM, Eric Blake <eblake-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On 10/19/2016 11:47 AM, Dan Williams wrote:
>> The 4.9 kernel added support for sub-dividing PMEM.  With this kernel
>> patch [1] on top of that baseline, the PMEM-sub-division support can be
>> enabled for QEMU-KVM and any other platforms that advertise both un-aliased
>> PMEM regions and support for the label DSM commands [2].
>>
>> Given this increasing need to perform a label management operation
>> across a set of DIMMs this update also adds glob(3) support.  For
>> example you can now write commands like:
>>
>>     ndctl zero-labels nmem[2-4]
>
> This is slightly scary, as it depends on the user not having any file
> named nmem2, nmem3, or nmem4 in the current working directory.  Your
> example should probably encourage proper shell quoting, as in:
>
> ndctl zero-labels 'nmem[2-4]'

True.  Although, the glob is run against the list of present device
names in the system, so local files named nmem should change the
operation of the command.
