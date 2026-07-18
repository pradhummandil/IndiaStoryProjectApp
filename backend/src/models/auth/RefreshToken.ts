import mongoose, { Schema, type HydratedDocument } from 'mongoose';

export interface RefreshToken {
  userId: mongoose.Types.ObjectId;
  tokenHash: string;
  expiresAt: Date;
  deviceInfo?: string;
  revoked: boolean;
  createdAt: Date;
  updatedAt: Date;
}

type RefreshTokenDocument = HydratedDocument<RefreshToken>;

const RefreshTokenSchema = new Schema<RefreshToken>(

  {
    userId: {
      type: Schema.Types.ObjectId,
      ref: 'User',
      required: true,
      index: true,
    },
    tokenHash: {
      type: String,
      required: true,
      minlength: 20,
      maxlength: 255,
      index: true,
    },
    expiresAt: { type: Date, required: true, index: true },
    deviceInfo: { type: String, required: false, default: '' },
    revoked: { type: Boolean, required: true, default: false, index: true },
  },
  { timestamps: true },
);

RefreshTokenSchema.index({ userId: 1, tokenHash: 1 }, { unique: true });

export const RefreshTokenModel = mongoose.model<RefreshTokenDocument>(
  'RefreshToken',
  RefreshTokenSchema,
);
