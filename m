From: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: xfstests xfs fuzzers fail with DAX
Date: Tue, 30 Aug 2016 07:53:41 -0700
Message-ID: <CAA9_cmfFMGQHTA_N5CGbXhdc=4qJsJbNJXu0WyUEJp7YguFo7Q@mail.gmail.com>
References: <20160804024514.GA2906@xzhoul.usersys.redhat.com>
 <CAPcyv4g1CkMZoq+vHcyPZW3ME7Qr=6pW10BTxg2n+e+28+MFKA@mail.gmail.com>
 <20160830023727.GH22760@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20160830023727.GH22760-PTl6brltDGh4DFYR7WNSRA@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-nvdimm <linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, XFS Developers <xfs-VZNHf3L845pBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-nvdimm@lists.01.org

On Mon, Aug 29, 2016 at 7:37 PM, Darrick J. Wong
<darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
> On Mon, Aug 29, 2016 at 06:50:05PM -0700, Dan Williams wrote:
>> [ Adding Darrick on the off chance that this triggers an "aha, of
>> course it does!" ]
>
> Aha!  Of course it does!!! :)

Heh, thanks :).  And apologies to Dave for missing his earlier note
pointing out the delalloc failure, linux-nvdimm list ate the response.

>
>> Darrick these corruption tests you added to xfstests last year all
>> fail the same way with DAX enabled.  They spew:
>>
>>     "pwrite64: Structure needs cleaning"
>>
>> ...reports that are cleaned up by running without "-o dax".
>
> I think this happens because in non-dax mode, the pwrite is a buffered
> write and so long as we can create a delalloc reservation, everything
> is ok and nothing fails.  Whereas for dax we have to allocate the
> blocks for the pwrite immediately, thereby triggering the cntbt
> verifier error.
>
> Proceeding from the assumption "DAX behaves a lot like DIO", all the
> tests that rely on buffered mode semantics are going to choke if DAX
> is turned on without them knowing about it.
>
>> Alternatively you could sit back and watch me try to figure it out,
>> that should be quite entertaining... as a start I'll try to pin down a
>> stack trace when the error is returned.
>
> As for how to fix this, probably the best option is to change line 98
> to 'pwrite -W -S 0x62...' and update the output to include the
> 'structure needs cleaning' message.

I'll give it a shot.

> Or get rid of the mount option and require explicitly turning on DAX
> on a per-inode basis, which I think is where Dave is already going.

Yes, I think we can't run away from the dax mount option fast enough.
The semantics are different, so an application / administrator needs
to explicitly opt-in to DAX semantics per-inode otherwise we are
guaranteed to cause surprises.
